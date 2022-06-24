import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meta_transfer/pages/home_page.dart';

class StartUpPage extends StatefulWidget {
  @override
  _StartUpPageState createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  int currentPage = 0;
  PageController _pageController = new PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 600,
                child: PageView(
                  controller: _pageController,
                  children: [
                    onBoardPage(
                      "transfer",
                      "Transfer",
                      "With one click you can transfer your money.",
                    ),
                    onBoardPage(
                      "pay",
                      "Payment",
                      "We come with fast and convenient noon-cash payments.",
                    ),
                    onBoardPage(
                      "delivery",
                      "delivery",
                      "get your money at your door step.",
                    ),
                  ],
                  onPageChanged: (value) => {setCurrentPage(value)},
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) => getIndicator(index))),
            ],
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: changePage,
                child: Container(
                  height: 70,
                  width: 70,
                  margin: EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [Color(0xfff3953b), Color(0xffe57509)],
                          stops: [0, 1],
                          begin: Alignment.topCenter)),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  setCurrentPage(int value) {
    currentPage = value;
    setState(() {});
  }

  AnimatedContainer getIndicator(int pageNo) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 100),
        height: 10,
        width: (currentPage == pageNo) ? 20 : 10,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: (currentPage == pageNo) ? Colors.orange : Colors.grey));
  }

  Column onBoardPage(String img, String title, String details) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 400,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(50),
           child:
          Lottie.asset(
            "assets/$img.json",
            // By default our  icon color is white
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 30,
                fontFamily: 'roboto',
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          child: Text(
            "$details",
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  void changePage() {
    print(currentPage);
    if (currentPage == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      _pageController.animateToPage(currentPage + 1,
          duration: Duration(milliseconds: 200), curve: Curves.linear);
    }
  }
}
