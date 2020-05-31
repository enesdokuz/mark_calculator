import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String lessonName;
  int lessonCredit = 1;
  double lessonValue = 4.0;
  List<Lesson> allLessons;
  double average = 0.0;
  var formKey = GlobalKey<FormState>();
  static int counterForKey = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allLessons = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mark Calculator"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
        child: Icon(Icons.add),
      ),
      body: appBody(),
    );
  }

  appBody() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Container(
              padding: EdgeInsets.only(right: 10, left: 10, top: 10),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "Lesson name",
                            hintText: "Please input lesson name",
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value.length > 0) {
                            return null;
                          } else {
                            return "Lesson Name must be full";
                          }
                        },
                        onSaved: (value) {
                          setState(() {
                            lessonName = value;
                            allLessons.add(
                                Lesson(lessonName, lessonValue, lessonCredit));
                            calculateAverage();
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                  items: lessonCreditItems(),
                                  value: lessonCredit,
                                  onChanged: (value) {
                                    setState(() {
                                      lessonCredit = value;
                                    });
                                  }),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                          Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<double>(
                                items: lessonValuesItems(),
                                value: lessonValue,
                                onChanged: (value) {
                                  setState(() {
                                    lessonValue = value;
                                  });
                                },
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          allLessons.length == 0
                              ? "Please add lesson"
                              : "Average: ${average.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 25,
                              color: average > 2.0
                                  ? Colors.green.shade600
                                  : Colors.red.shade600),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade200,
              child: ListView.builder(
                itemBuilder: _generateListItems,
                itemCount: allLessons.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  lessonCreditItems() {
    List<DropdownMenuItem<int>> credits = [];
    for (int i = 1; i < 20; i++) {
      credits.add(DropdownMenuItem(
        child: Text(
          ("$i Credit"),
          style: TextStyle(fontSize: 20),
        ),
        value: i,
      ));
    }
    return credits;
  }

  lessonValuesItems() {
    List<DropdownMenuItem<double>> values = [];
    values.add(DropdownMenuItem(
        child: Text("AA", style: TextStyle(fontSize: 20)), value: 4));
    values.add(DropdownMenuItem(
        child: Text("BA", style: TextStyle(fontSize: 20)), value: 3.5));
    values.add(DropdownMenuItem(
        child: Text("BB", style: TextStyle(fontSize: 20)), value: 3));
    values.add(DropdownMenuItem(
        child: Text("CB", style: TextStyle(fontSize: 20)), value: 2.5));
    values.add(DropdownMenuItem(
        child: Text("CC", style: TextStyle(fontSize: 20)), value: 2));
    values.add(DropdownMenuItem(
        child: Text("DC", style: TextStyle(fontSize: 20)), value: 1.5));
    values.add(DropdownMenuItem(
        child: Text("DD", style: TextStyle(fontSize: 20)), value: 1));
    values.add(DropdownMenuItem(
        child: Text("FD", style: TextStyle(fontSize: 20)), value: 0.5));
    values.add(DropdownMenuItem(
        child: Text("FF", style: TextStyle(fontSize: 20)), value: 0));
    return values;
  }

  Widget _generateListItems(BuildContext context, int index) {
    counterForKey++;
    return Dismissible(
      key: Key(counterForKey.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          allLessons.removeAt(index);
          calculateAverage();
        });
      },
      child: Card(
        child: ListTile(
          title: Text(allLessons[index].name.toString()),
          subtitle: Text(allLessons[index].credit.toString() +
              " credit Lesson Mark: " +
              allLessons[index].value.toString()),
        ),
      ),
    );
  }

  void calculateAverage() {
    if (allLessons.length == 0) {
      average = 0.0;
      return;
    }

    int totalCredits = 0;
    double totalValues = 0;

    for (var lesson in allLessons) {
      totalCredits += lesson.credit;
      totalValues += (lesson.value * lesson.credit);
    }
    average = (totalValues / totalCredits);
  }
}

class Lesson {
  String name;
  double value;
  int credit;

  Lesson(this.name, this.value, this.credit);
}
