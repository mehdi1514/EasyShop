import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'dart:async';
import 'dart:typed_data';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Shop',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: AnotherHome(),
    );
  }
}

class AnotherHome extends StatefulWidget {
  @override
  _AnotherHomeState createState() => _AnotherHomeState();
}

class _AnotherHomeState extends State<AnotherHome> {
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  List<Map<String, dynamic>> addedItems = [];
  double totalAmount = 0;
  @override
  initState() {
    super.initState();
  }
  showConfirmedDialog(BuildContext context) {

    Widget okButton = FlatButton(
      child: Text("Okay"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Icon(
        Icons.done, 
        color: Colors.orange, 
        size: MediaQuery.of(context).size.width * 0.25,
      ),
      content: Text(
        "Payment Successful",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05,
          fontWeight: FontWeight.bold
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showPaymentDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {Navigator.pop(context);},
    );
    Widget confirmButton = FlatButton(
      child: Text("Confirm"),
      onPressed:  () {
        setState(() {
          addedItems.clear();
          totalAmount = 0;
        });
        Navigator.pop(context);
        showConfirmedDialog(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Confirm Payment?",
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.065,
          fontWeight: FontWeight.bold
        ),
      ),
      content: Text(
        "Subtotal: $totalAmount",
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.05,
        ),
      ),
      actions: [
        cancelButton,
        confirmButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Easy Shop", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () => _scan(),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                //height: 50.0,
                child: ListView.builder(
                  itemCount: addedItems.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: IconButton(
                              icon: Icon(Icons.remove),
                              color: Colors.white,
                              onPressed: () {
                                setState(() {
                                  addedItems.removeAt(index);
                                });
                              },
                            ),
                          ),
                          title: Text(addedItems[index]['name']),
                          trailing: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(addedItems[index]['price'].toString()),
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                ),
              ),
            ),
            /*SizedBox(
                width: 200,
                height: 200,
                child: Image.memory(bytes),
              ),*/
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: () {
                        showPaymentDialog(context);
                      },
                      child: Text(
                        "Pay",
                        style: TextStyle(color: Colors.white),
                      ),
                      elevation: 3.0,
                      splashColor: Colors.orangeAccent,
                      color: Colors.orange,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "\$ ${totalAmount.toString()}",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06
                    ),
                  ),
                )
              ],
            )
            //Text('RESULT  $barcode'),
            //RaisedButton(onPressed: () => _scan("apples", 15.0), child: Text("Scan")),
            //RaisedButton(onPressed: _scanPhoto, child: Text("Scan Photo")),
            //RaisedButton(onPressed: _generateBarCode, child: Text("Generate Barcode")),
          ],
        ),
      ),
    );
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() {
      this.barcode = barcode;
      double price =  double.parse(barcode.substring((barcode.indexOf(",")+1)));
      this.totalAmount += price;
      String name = barcode.substring(0,barcode.indexOf(","));
      this.addedItems.add({"name": name, "price": price});
    });
  }

  /*Future _scanPhoto() async {
    String barcode = await scanner.scanPhoto();
    setState(() => this.barcode = barcode);
  }*/

  /*Future _generateBarCode() async {
    Uint8List result = await scanner.generateBarCode('apples, price: 5 rupees');
    this.setState(() => this.bytes = result);
  }*/
}
