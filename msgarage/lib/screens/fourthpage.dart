import 'package:flutter/material.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  List<String> mat = ['2022', '2057', '2000'];
  String selectedMat = '2022';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF002E7F),
        title: Text(
          'Historiques',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Add your logic to handle the menu icon click here
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                value: selectedMat,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMat = newValue!;
                  });
                },
                items: mat.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Immatriculation',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.0), // Add some spacing between dropdown and cards
              buildCardWithBar('assets/images/bleu.png', 'Card 1', 'Description for Card 1'),
              SizedBox(height: 10.0), // Add some spacing between the cards
              buildCardWithBar('assets/images/bleu.png', 'Card 2', 'Description for Card 2'),
              SizedBox(height: 10.0), // Add some spacing between the cards
              buildCardWithBar('assets/images/bleu.png', 'Card 3', 'Description for Card 3'),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardWithBar(String imagePath, String title, String subtitle) {
    return Container(
      height: 100.0, // Set the desired height for the cards
      child: Row(
        children: [
          Container(
            width: 8.0, // Width of the blue bar
            color: Color(0xFF002E7F), // Color of the blue bar
          ),
          SizedBox(width: 10.0), // Add some spacing between the blue bar and the card
          Expanded(
            child: Card(
              elevation: 10.0, // Set the elevation for the card
              child: Container(
                height: 100.0, 
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(subtitle),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
