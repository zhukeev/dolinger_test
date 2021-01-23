import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'second_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dolinger Test',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          inputDecorationTheme:
              InputDecorationTheme(border: OutlineInputBorder())),
      home: MyHomePage(title: 'Dolinger\'s Test First Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final urlTEC = TextEditingController();
  final numberTEC = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: urlTEC,
                  decoration: InputDecoration(labelText: 'URL to an image'),
                  validator: (value) {
                    final urlRegExp = new RegExp(
                        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
                    final isValidUrl = urlRegExp.hasMatch(value);
                    return isValidUrl ? null : 'Invalid url format';
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: numberTEC,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.allow(RegExp(r'([3-5])'))
                  ],
                  validator: (value) {
                    return value?.isEmpty ?? true
                        ? 'Field can\'t be empty'
                        : null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Any integer number between 3 and 5'),
                ),
                SizedBox(height: 16),
                FlatButton(
                    onPressed: () {
                      if (_globalKey.currentState.validate()) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => SecondPage(
                                  imageUrl: urlTEC.text,
                                  additionallyQuntity:
                                      int.parse(numberTEC.text),
                                )));
                      }
                    },
                    child: Text('GO TO THE SECOND PAGE')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
