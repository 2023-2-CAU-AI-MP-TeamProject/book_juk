import 'package:book_juk/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'MyAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum LoginPlatform {
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
    if(_loginPlatform == LoginPlatform.kakao) {
      return "Loginned with kakao";
    } else if(_loginPlatform == LoginPlatform.google) {
      return "Loginned with google";
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (_loginPlatform == LoginPlatform.none) ? InkWell(
            onTap: kakaoLogin,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/kakao_login_large_wide.png',
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
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/android_light_sq_SI@2x.png',
                fit:BoxFit.fitWidth
              )
            ),
          ) : Container(),
          Text(_loginText(), style: const TextStyle(fontSize: 20),),
          TextButton(
            onPressed: signOut,
            child: const Text('로그아웃',
              style: TextStyle(
                color: Colors.blue
              )
            )
          )
        ],
      ) 
    );
  }

  void kakaoLogin() async {
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
    setState(() {});
  }

  Future<void> kakaoSendInfo(OAuthToken token) async {
    var provider = OAuthProvider('oidc.kakao'); // 제공업체 id
    var credential = provider.credential(
      idToken: token.idToken, 
      // 카카오 로그인에서 발급된 idToken(카카오 설정에서 OpenID Connect가 활성화 되어있어야함)
      accessToken: token.accessToken, // 카카오 로그인에서 발급된 accessToken
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    if (context.mounted) {
        const SnackBar sb = SnackBar(
          content: Text('Loginned with kakao.'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(sb);
    }
  }

  Future<void> googleLogin() async {
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
          const SnackBar sb = SnackBar(
            content: Text('Loginned with google.'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(sb);
      }
    } catch(error) {
      print('구글계정으로 로그인 실패 $error');
      _loginPlatform = LoginPlatform.none;
    }
    setState(() {});
  }

  Future<void> googleLoginWeb() async {
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
            const SnackBar sb = SnackBar(
              content: Text('Loginned with google.'),
              duration: Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).showSnackBar(sb);
        }
    } catch(error) {
      print('구글계정으로 로그인 실패 $error');
      _loginPlatform = LoginPlatform.none;
    }
    setState(() {});
  }

  Future<void> signOut() async {
    switch(_loginPlatform){
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        await FirebaseAuth.instance.signOut();
        break;
      case LoginPlatform.google:
        await FirebaseAuth.instance.signOut();
        break;
      case LoginPlatform.none:
        break;
    }
  
    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
    print('로그아웃됨');
  }
}

