import 'package:book_juk/firebase/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
//카카오 또는 구글 계정을 이용하여 로그인할 수 있다.
//로그인된 계정마다 파이어베이스에 정보가 저장되고 로그아웃을 해도 책의 정보가 남아있게 해준다.
//담당: 이재인
enum LoginPlatform { //카카오 또는 구글로 로그인
  kakao,
  google,
  none,
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  LoginPlatform _loginPlatform = LoginPlatform.none;

  String _loginText() {
    if(_loginPlatform == LoginPlatform.kakao) { //카카오 또는 구글로 로그인
      return "Loginned with kakao";
    } else if(_loginPlatform == LoginPlatform.google) {
      return "Loginned with google";
    } else {
      return "";
    }
  }

  void setLoginState(String loginPlatform) async { //로그인 상태를 확인한다.
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString("login_platform", loginPlatform);
      _loginPlatform = _loginPlatform;
    });
    if(_loginPlatform != LoginPlatform.none && context.mounted){
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
    else if(context.mounted){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context) => const Login())), (route) => false,);
    }
  }

  Future<String> getLoginState() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("login_platform") ?? "loginPlatform.none";
  }

  Future<LoginPlatform> checkLoginState() async {
    String loginState = await getLoginState();
    switch(loginState){
      case "LoginPlatform.kakao":
        return LoginPlatform.kakao;
      case "LoginPlatform.google":
        return LoginPlatform.google;
      case "LoginPlatform.none":
      default:
        return LoginPlatform.none;
    }
  }

  @override
  void initState(){
    super.initState();
    if(_loginPlatform == LoginPlatform.none){
      checkLoginState()
      .then(
        (value) {
          setState(() {
            _loginPlatform = value;
          });
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) { //로그인 화면
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Image.asset('assets/logo.png',
              fit:BoxFit.contain
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.width / 10),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Center(
              child: Text(
                "책:크 - 나만의 책꽂이",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 15
                ),
              )
            )
          ),
          SizedBox(height: MediaQuery.of(context).size.width / 5),
          Column(
            children: [
              (_loginPlatform == LoginPlatform.none) ? InkWell(
                onTap: kakaoLogin,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Image.asset('assets/kakao.png',
                    fit:BoxFit.fitWidth
                  )
                ),
              ) : Container(),
              (_loginPlatform == LoginPlatform.none) ? InkWell(
                onTap: () {
                  if(DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web){
                    googleLoginWeb();
                  } else {
                    googleLogin();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Image.asset('assets/google.png',
                    fit:BoxFit.fitWidth
                  )
                ),
              ) : Container(),
            ]
          ),
          Text(_loginText(), style: const TextStyle(fontSize: 20),),
          (_loginPlatform != LoginPlatform.none) ? TextButton(
            onPressed: signOut,
            child: const Text('로그아웃',
              style: TextStyle(
                color: Colors.blue
              )
            )
          )
          : Container()
        ],
      ) 
    );
  }

  void kakaoLogin() async { //카카오 로그인 동작 구현
    showLoading(context);
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        await kakaoSendInfo(token);
        print('카카오톡으로 로그인 성공');
        _loginPlatform = LoginPlatform.kakao;
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
        _loginPlatform = LoginPlatform.none;

        if (error is PlatformException && error.code == 'CANCELED') {
          _loginPlatform = LoginPlatform.none;
          return;
        }
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          await kakaoSendInfo(token);
          print('카카오계정으로 로그인 성공');
          _loginPlatform = LoginPlatform.kakao;
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          _loginPlatform = LoginPlatform.none;
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        await kakaoSendInfo(token);
        print('카카오계정으로 로그인 성공');
        _loginPlatform = LoginPlatform.kakao;
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        _loginPlatform = LoginPlatform.none;
      }
    }
    setLoginState(_loginPlatform.toString());
  }

  Future<void> kakaoSendInfo(OAuthToken token) async {
    var provider = OAuthProvider('oidc.kakao'); // 제공업체 id
    var me = await UserApi.instance.me();
    var credential = provider.credential(
      idToken: token.idToken, 
      // 카카오 로그인에서 발급된 idToken(카카오 설정에서 OpenID Connect가 활성화 되어있어야함)
      accessToken: token.accessToken, // 카카오 로그인에서 발급된 accessToken
    );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = userCredential.user;
    await user!.updateDisplayName(me.kakaoAccount!.profile!.nickname);
    await user.updatePhotoURL(me.kakaoAccount!.profile!.profileImageUrl);
    if(me.kakaoAccount!.email != null){
      await user.updateEmail(me.kakaoAccount!.email!);
    }
    print(me.kakaoAccount!.profile!.profileImageUrl);

    if (context.mounted) {
      SnackBar sb = const SnackBar(
        content: Text('Loginned with kakao'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(sb);
    }
  }

  void googleLogin() async { //구글 로그인 구현
    showLoading(context);
    try{
        // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);

      print('구글계정으로 로그인 성공');
      _loginPlatform = LoginPlatform.google;
      if (context.mounted) {
        SnackBar sb = const SnackBar(
          content: Text('Loginned with google'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(sb);
      }
    } catch(error) {
      print('구글계정으로 로그인 실패 $error');
      _loginPlatform = LoginPlatform.none;
    }
    setLoginState(_loginPlatform.toString());
  }

  Future<void> googleLoginWeb() async {
    showLoading(context);
    try{
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({
        'login_hint': 'user@example.com'
      });

      await FirebaseAuth.instance.signInWithPopup(googleProvider);
      
      print('구글계정으로 로그인 성공');
      _loginPlatform = LoginPlatform.google;
      if (context.mounted) {
        SnackBar sb = const SnackBar(
          content: Text('Loginned with google'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(sb);
      }
    } catch(error) {
      print('구글계정으로 로그인 실패 $error');
      _loginPlatform = LoginPlatform.none;
    }
    setLoginState(_loginPlatform.toString());
  }

  Future<void> signOut() async {
    showLoading(context);
    switch(_loginPlatform){
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        await FirebaseAuth.instance.signOut();
        break;
      case LoginPlatform.google:
        await FirebaseAuth.instance.signOut();
        break;
      case LoginPlatform.none:
        if(context.mounted){
          const SnackBar sb = SnackBar(
            content: Text('Already logoutted.'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(sb);
          return;
        }
    }
    _loginPlatform = LoginPlatform.none;
    setLoginState(_loginPlatform.toString());
    print('로그아웃됨');
  }

  void showLoading(BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator()
            ),
          ),
        );
      }
    );
  }
}