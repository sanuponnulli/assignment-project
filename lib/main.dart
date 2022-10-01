import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyWidget());
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<Map<String, dynamic>> product = [];
  // [
  //   {
  //     "p_name": "Apple",
  //     "pic":
  //         "https://5.imimg.com/data5/LM/DU/MY-22954806/apple-fruit-500x500.jpg",
  //     "p_id": 1,
  //     "p_cost": 30,
  //     "p_availability": 1,
  //     "p_details": "Imported from Swiss",
  //     "p_category": "Premium"
  //   },
  //   {
  //     "p_name": "Mango",
  //     "pic": "https://www.svz.com/wp-content/uploads/2018/05/Mango.jpg",
  //     "p_id": 2,
  //     "p_cost": 50,
  //     "p_availability": 1,
  //     "p_details": "Farmed at Selam",
  //     "p_category": "Tamilnadu"
  //   },
  //   {
  //     "p_name": "Bananna",
  //     "pic":
  //         "https://5.imimg.com/data5/VY/QT/MY-51857835/banana-fruit-500x500.jpg",
  //     "p_id": 3,
  //     "p_cost": 5,
  //     "p_availability": 0,
  //   },
  //   {
  //     "p_name": "Orange",
  //     "pic":
  //         "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Orange-Fruit-Pieces.jpg/1200px-Orange-Fruit-Pieces.jpg",
  //     "p_id": 4,
  //     "p_cost": 25,
  //     "p_availability": 1,
  //     "p_details": "from Nagpur",
  //     "p_category": "Premium"
  //   }
  // ];
  final category = ["Premium", "Tamilnadu"];
  List<Map<String, dynamic>> cart = [];
  bool prem = false;
  bool tam = false;
  TextEditingController qu = TextEditingController();
  List<Map<String, dynamic>> result = [];
  Future<void> fetch() async {
    await DefaultAssetBundle.of(context)
        .loadString("assets/data.json")
        .then((value) => product = (json.decode(value) as List).cast())
        .then((value) => append(false, false));

    setState(() {});
    // product = (json.decode(d) as List).cast();
    // print(product);
  }

  void append(bool premium, bool tamilnadu) {
    if (premium == false && tamilnadu == false) {
      result.addAll(product);
    } else {
      for (Map<String, dynamic> i in product) {
        if (i["p_category"] == "Premium" && premium) {
          result.add(i);
        } else if (i["p_category"] == "Tamilnadu" && tamilnadu) {
          result.add(i);
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetch();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(result);
    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),
              Text("Filter"),
              CheckboxListTile(
                title: Text("Premium"),
                value: prem,
                onChanged: (newValue) {
                  setState(() {
                    prem = newValue as bool;
                    result.clear();
                    append(prem, tam);
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
              CheckboxListTile(
                title: Text("Tamilnadu"),
                value: tam,
                onChanged: (newValue) {
                  setState(() {
                    tam = newValue as bool;
                    result.clear();
                    append(prem, tam);
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        actions: [
          GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(15)),
                      content: Container(
                        // decoration: BoxDecoration(
                        //   border: Border.all(width: 2, color: Colors.green),
                        //   borderRadius: BorderRadius.all(Radius.circular(15)),
                        // ),
                        height: 500,
                        width: 200,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: cart.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Color.fromARGB(108, 76, 175, 79),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                leading:
                                    Text("${cart[index]["p_name"].toString()}"),
                                trailing: Text(
                                    "Quantity: ${cart[index]["quantity"].toString()}"),
                              );
                            }),
                      ),
                      title: Text("Add quantity"),
                      actions: [
                        TextButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.shopping_cart_checkout))
        ],
        title: Text("Products"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text("products"),
            Expanded(
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.green),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.network(
                                result[index]["pic"] ??
                                    "https://user-images.githubusercontent.com/24848110/33519396-7e56363c-d79d-11e7-969b-09782f5ccbab.png",
                                scale: 1,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(result[index]["p_name"],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300)),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      "Details: ${result[index]["p_details"] ?? "Not Provided"}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                  Text(
                                    "Category: ${result[index]["p_category"] ?? "Not Provided"}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  Text(
                                    "Price: ${result[index]["p_cost"].toString()} .Rs",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                              Spacer(),
                              GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.green,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          title: Text("Add quantity"),
                                          actions: [
                                            TextField(
                                              decoration: InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .green,
                                                                  width: 2)),
                                                  hintText: 'Enter quantity',
                                                  contentPadding:
                                                      const EdgeInsets.all(15),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30))),
                                              controller: qu,
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                            TextButton(
                                              child: Text("OK"),
                                              onPressed: () {
                                                // print(qu.text);
                                                if (qu.text != "") {
                                                  Map<String, dynamic> s =
                                                      result[index];
                                                  s["quantity"] = qu.text;
                                                  cart.add(s);
                                                  cart = cart.toSet().toList();
                                                }
                                                // print(cart);
                                                qu.clear();
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(Icons.shopping_cart))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 15);
                  },
                  itemCount: result.length),
            )
          ],
        ),
      )),
    );
  }
}
