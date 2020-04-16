import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'SocialIcons.dart';
import 'CustomIcons.dart';
import 'dart:convert';
import 'register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(
  home: MyApp(),
  debugShowCheckedModeBanner: false,
));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

enum LoginStatus {notSignIn, signIn}
LoginStatus _loginStatus = LoginStatus.notSignIn;
String username, password;
final _key = new GlobalKey<FormState>();
bool _secureText = true;

class _MyAppState extends State<MyApp> {
  bool _isSelected = false;
  
  showHide(){
    setState((){
      _secureText = !_secureText;
    });
  }

  check(){
    final form = _key.currentState;
    if (form.validate()){
      form.save();
      login();
    }
  }

  login() async{
    final response = await http.post("http://apikelvin2019.000webhostapp.com/login.php",
          body: {"username" : username, "password" : password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String user = data['username'];
    String nama = data['nama'];
    String id = data['id'];
    if (value == 1){
      setState((){
        _loginStatus = LoginStatus.signIn;
        savePref(value, user, nama, id);
      });
      print(message);
    }else{
      print(message);
    }
  }

  savePref(int value, String username, String nama, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState((){
      preferences.setInt("value", value);
      preferences.setString("nama", nama);
      preferences.setString("username", username);
      preferences.setString("id", id);
      preferences.commit();
    });
  }

  var value;

  getPref() async{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState((){
        value = preferences.getInt("value");
        _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
      });
  }

  signOut() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState((){
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState(){
    super.initState();
    getPref();
  }

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    switch(_loginStatus){
      case LoginStatus.notSignIn:
        return new Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: true,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Image.asset("assets/covid.jpg"),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Image.asset("assets/image_02.png")
                ],
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[Image.asset("assets/logo2.png")]
                      ),
                      SizedBox(height: ScreenUtil.getInstance().setHeight(200)),
                      Container(
                        width: double.infinity,
                        height: ScreenUtil.getInstance().setHeight(460),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, 15.0),
                              blurRadius: 15.0
                            ),
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, -10.0),
                              blurRadius: 10.0
                            )
                          ]
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Masuk",
                                style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(45),
                                  fontFamily: "Poppins-Bold",
                                  letterSpacing: .6
                                )
                              ),
                              TextFormField(
                                validator: (e){
                                  if (e.isEmpty){
                                    return "Isi Nama Pengguna terlebih dahulu";
                                  }
                                },
                                onSaved: (e) => username = e,
                                decoration: InputDecoration(
                                  labelText: "Nama Pengguna",
                                  labelStyle: TextStyle(color: Colors.grey, fontSize: 15.0)
                                ),
                              ),
                              TextFormField(
                                validator: (e){
                                  if (e.isEmpty){
                                    return "Isi Kata Sandi terlebih dahulu";
                                  }
                                },
                                obscureText: _secureText,
                                onSaved: (e) => password = e,
                                decoration: InputDecoration(
                                  labelText: "Kata Sandi",
                                  suffixIcon: IconButton(
                                    onPressed: showHide,
                                    icon: Icon(_secureText
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                ))),
                              SizedBox(
                                height: ScreenUtil.getInstance().setHeight(35),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "Lupa Kata Sandi?",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontFamily: "Poppins-Medium",
                                        fontSize: ScreenUtil.getInstance().setSp(28)),
                                  )
                                ],
                              )
                            ]
                          )
                        )
                      ),
                      SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 12.0,
                              ),
                              GestureDetector(
                                onTap: _radio,
                                child: radioButton(_isSelected),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text("Ingat Saya",
                                  style: TextStyle(
                                      fontSize: 12, fontFamily: "Poppins-Medium"))
                            ],
                          ),
                          InkWell(
                            child: Container(
                              width: ScreenUtil.getInstance().setWidth(330),
                              height: ScreenUtil.getInstance().setHeight(100),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color(0xFF17ead9),
                                    Color(0xFF6078ea)
                                  ]),
                                  borderRadius: BorderRadius.circular(6.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFF6078ea).withOpacity(.3),
                                        offset: Offset(0.0, 8.0),
                                        blurRadius: 8.0)
                                  ]),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  child: Center(
                                    child: Text("Masuk",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: "Poppins-Bold",
                                            fontSize: 18,
                                            letterSpacing: 1.0)),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(40),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          horizontalLine(),
                          Text("Media Sosial",
                              style: TextStyle(
                                  fontSize: 16.0, fontFamily: "Poppins-Medium")),
                          horizontalLine()
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(40),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SocialIcon(
                            colors: [
                              Color(0xFF102397),
                              Color(0xFF187adf),
                              Color(0xFF00eaf8),
                            ],
                            iconData: CustomIcons.facebook,
                            onPressed: () {},
                          ),
                          SocialIcon(
                            colors: [
                              Color(0xFFff4f38),
                              Color(0xFFff355d),
                            ],
                            iconData: CustomIcons.googlePlus,
                            onPressed: () {},
                          ),
                          SocialIcon(
                            colors: [
                              Color(0xFF17ead9),
                              Color(0xFF6078ea),
                            ],
                            iconData: CustomIcons.twitter,
                            onPressed: () {},
                          ),
                          SocialIcon(
                            colors: [
                              Color(0xFF00c6fb),
                              Color(0xFF005bea),
                            ],
                            iconData: CustomIcons.linkedin,
                            onPressed: () {},
                          )
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(30),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Tidak Punya Akun? ",
                            style: TextStyle(fontFamily: "Poppins-Medium"),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return RegisterPage();
                              }));
                            },
                            child: Text("Daftar",
                                style: TextStyle(
                                    color: Color(0xFF5d74e3),
                                    fontFamily: "Poppins-Bold")),
                          )
                        ],
                      )
                    ],
                  )
                )
              )
            ],
          )
        );
      break;
      case LoginStatus.signIn:
        return Dashboard(signOut);
      break;
    }
  }
}

class Dashboard extends StatefulWidget {
  final VoidCallback signOut;
  Dashboard(this.signOut);

  @override
  _DashboardState createState() => _DashboardState ();
}

class _DashboardState extends State<Dashboard>{
  signOut(){
    setState(() {
      widget.signOut();
    });
  }
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {});
  }
  @override
  void initState(){
    super.initState();
    getPref();
  }

  @override
  Widget build (BuildContext context){
    return Scaffold (
      appBar: AppBar(title: Text ("Dashboard"), leading : Icon(Icons.home)),
      body: new Container (
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("halo selamat datang di dashboard", 
            style: new TextStyle(fontSize:20.0)),
            ButtonTheme(
            minWidth: MediaQuery.of(context).size.width,
            child: new Container(
              margin: const EdgeInsets.all(16.0),
              child: new RaisedButton(onPressed: () {
                signOut();
              },
              color: Colors.blue,
              textColor: Colors.white, 
              child: Text("Logout")),
            )),
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              child: new Container(
                margin: const EdgeInsets.only(top: 8.0, left:8.0, bottom:8.0, right: 8.0),
                child: new RaisedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return RegisterPage();
                    }));
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("Daftar Mahasiswa")
                ),
              )
            ),
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              child: new Container(
                margin: const EdgeInsets.only(top: 8.0, left:8.0, bottom:8.0, right: 8.0),
                child: new RaisedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return RegisterPage();
                    }));
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text("Profile")
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}