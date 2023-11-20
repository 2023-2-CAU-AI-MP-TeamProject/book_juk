import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'MyAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum LoginPlatform {
  kakao,
  none,
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  LoginPlatform _loginPlatform = LoginPlatform.none;
  bool _hasToken = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (!_hasToken) ? InkWell(
            onTap: kakaoLogin,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/kakao_login_large_wide.png',
                fit:BoxFit.fitWidth
              )
            ),
          ) : Container(),
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
        await sendInfo(token);
        print('카카오톡으로 로그인 성공');
        _hasToken = true;
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
        _hasToken = false;

        if (error is PlatformException && error.code == 'CANCELED') {
          _hasToken = false;
          return;
        }
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          await sendInfo(token);
          print('카카오계정으로 로그인 성공');
          _hasToken = true;
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          _hasToken = false;
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        await sendInfo(token);
        print('카카오계정으로 로그인 성공');
        _hasToken = true;
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        _hasToken = false;
      }
    }
    setState(() {});
  }

  Future<void> sendInfo(OAuthToken token) async {
    var provider = OAuthProvider('oidc.kakao'); // 제공업체 id
    var credential = provider.credential(
      idToken: token.idToken, 
      // 카카오 로그인에서 발급된 idToken(카카오 설정에서 OpenID Connect가 활성화 되어있어야함)
      accessToken: token.accessToken, // 카카오 로그인에서 발급된 accessToken
    );
      FirebaseAuth.instance.signInWithCredential(credential);
    if (context.mounted) {
        const SnackBar sb = SnackBar(
          content: Text('Loginned'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(sb);
      }
  }

  Future<void> signOut() async {
    switch(_loginPlatform){
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        await FirebaseAuth.instance.signOut();
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
      _hasToken = false;
    });
    print('로그아웃됨');
  }
}

