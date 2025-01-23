import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:flutter/services.dart' as rootBundle; // For loading assets
import 'package:gloceryshoping/Auth/Authservice.dart';
// import '../pages/detail.dart';
import 'detail.dart';
import 'cart.dart';
import 'package:provider/provider.dart';
import 'cart_model.dart';
class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<dynamic> categories = [];
  List<dynamic> popularItems = [];
  List<dynamic> topProducts = [];
  List<dynamic> filteredProducts = []; // To store filtered products
  TextEditingController searchController = TextEditingController(); 
  // Load local JSON file
  Future<void> loadData() async {
    // Load the local JSON file from assets
    final String response = await rootBundle.rootBundle.loadString('assets/data.json');
    final data = json.decode(response);

    setState(() {
      categories = data['categories'];
      popularItems = data['popular'];
      topProducts = data['topProducts'];
      filteredProducts = topProducts;
    });
  }

  void logout() async {
    await AuthService().signOut();
  }

   void _searchProduct(String query) {
    if (query.isNotEmpty) {
      // Find the product that matches the search query
      final foundProduct = topProducts.firstWhere(
        (product) => product['title'].toLowerCase().contains(query.toLowerCase()) || 
                    product['explain'].toLowerCase().contains(query.toLowerCase()), 
        orElse: () => null,
      );

      // If a product is found, navigate to the DetailPage
      if (foundProduct != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(product: foundProduct),
          ),
        );
      } else {
        // Handle case where no product is found (optional)
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("No Product Found"),
            content: Text("No products matched your search query."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadData(); // Load data when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.green,
  elevation: 0,
  title: const Text(
    "Welcome",
    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  ),
  actions: [
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
      label: const Text("Go to Cart", style: TextStyle(color: Colors.white)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartPage()),
        );
      },
    ),
    const SizedBox(width: 10),// Optional: Add spacing between the button and the edge

    IconButton(
      icon: const Icon(Icons.logout, color: Colors.white),
      onPressed: logout
    ),

  ],
),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            _buildSearchBar(),

            const SizedBox(height: 10),

            // Category Section
            _buildSectionTitle("Category"),
            _buildHorizontalList(categories),

            const SizedBox(height: 10),

            // Popular Section
            _buildSectionTitle("Popular"),
            _buildHorizontalList(popularItems),

            const SizedBox(height: 10),

            // Top Products Grid
            _buildSectionTitle("Top"),
            _buildProductGrid(topProducts),
          ],
        ),
      ),
    );
  }

  // Search Bar
   Widget _buildSearchBar() {
    return Container(
      color: Colors.green,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Search here...",
          prefixIcon: GestureDetector(
            onTap: () {
              _searchProduct(searchController.text); // Trigger search when icon is clicked
            },
            child: const Icon(Icons.search, color: Colors.black),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Section Title with 'See All'
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        
        ],
      ),
    );
  }

  // Horizontal List View
 Widget _buildHorizontalList(List<dynamic> items) {
  return SizedBox(
    height: 65,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(left: 12),
          width: 160,
          child: Card(
            color: Colors.white,
            elevation: 4, // Adds shadow effect to the card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Rounded corners
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align items to the start
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)), // Rounded top corners
                    child: Image.asset(
                      items[index]['image'],
                      fit: BoxFit.scaleDown,
                      width: double.infinity, // Make sure image takes full width
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0), // Add padding to the right of the text
                  child: Text(
                    items[index]['title'],
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}



  // Product Grid for Top Section
 Widget _buildProductGrid(List<dynamic> products) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(product: products[index]),
              ),
            );
          },
          child: Container(
            
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    products[index]['image'],
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                Text(products[index]['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold ,fontSize: 20)),
                    const SizedBox(height: 10),
                Text(products[index]['explain'],
                    style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                
                // Row for price and cart button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "\$${products[index]['price']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined,
                              color: Colors.white),
                           onPressed: () {
                    Provider.of<CartModel>(context, listen: false)
                        .addToCart(products[index], 1);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${products[index]['title']} added to cart')),
                    );
                  },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
}