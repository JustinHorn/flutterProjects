import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First Page"),
      ),
      body: Center(
          child: MaterialButton(
        color: Colors.redAccent,
        child: Text("Second Page"),
        onPressed: () {
          Navigator.push(
            context,
            BouncyPageRoute(widget: SecondScreeen()),
          );
        },
      )),
    );
  }
}

class BouncyPageRoute extends PageRouteBuilder {
  final Widget widget;

  BouncyPageRoute({this.widget})
      : super(
          transitionDuration: Duration(milliseconds: 2000),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secAnimation,
              Widget child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(animation),
              child: SlideTransition(
                position: Tween(
                  begin: Offset.zero,
                  end: const Offset(0.0, -0.5),
                ).animate(secAnimation),
                child: child,
              ),
            );
          },
          pageBuilder: (context, animation, secAnimation) {
            return widget;
          },
        );
}

class SecondScreeen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Second Screen"),
      ),
      body: Center(
        child: MaterialButton(
          color: Colors.blueGrey,
          child: Text("Third Screen"),
          onPressed: () {
            Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 2000),
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secAnimation,
                      Widget child) {
                    return SlideTransition(
                      position: Tween(
                        begin: const Offset(0.0, 1.0),
                        end: const Offset(0.0, 0.5),
                      ).animate(animation),
                      child: SlideTransition(
                        position: Tween(
                          begin: Offset.zero,
                          end: const Offset(0.0, -0.5),
                        ).animate(secAnimation),
                        child: child,
                      ),
                    );
                  },
                  pageBuilder: (context, animation, secAnimation) {
                    return ThirdScreen();
                  },
                ));
          },
        ),
      ),
    );
  }
}

class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("Third Screen"),
        ),
        body: Center(child: Text("THIRD SCREEN")));
  }
}
