import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DummyPage extends StatelessWidget {
  const DummyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
      ),
      body: Center(child: Text("Home Page Sementara")),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  final int _totalPage = 3;
  bool get isFirstPage => _currentIndex == 0;
  bool get isLastPage => _currentIndex == _totalPage - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 85, //bagian atas
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                _buildSlide(
                  image: 'assets/Vector (3).png',
                  title: 'STEM Masih Sepi \n Perempuan?',
                  subtitle: TextSpan(
                    text:
                        'Dunia STEM butuh lebih banyak sama \n perempuan termasuk kamu',
                  ),
                ),
                _buildSlide(
                  image: 'assets/Vector (4).png',
                  title: 'Pernah Ngerasa \n Minder?',
                  subtitle: TextSpan(
                    text:
                        'Stereotip bukan batas itu cuma \n cerita lama yang perlu diganti',
                  ),
                ),
                _buildSlide(
                  image: 'Vector@2x.png',
                  title: 'Ilmu Tak Lagi Langka \n Kolaborasi Jadi Nyata',
                  subtitle: TextSpan(
                    children: [
                      TextSpan(
                        text: "Belajar ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: "Dengan "),
                      TextSpan(
                        text: "Percaya diri\n",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: "Tumbuh ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: "Dengan "),
                      TextSpan(
                        text: "dukungan \n",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: "Sukses ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: "Dengan "),
                      TextSpan(
                        text: "Solidaritas ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 70),
          Flexible(
            //bagian bawah
            flex: 15,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      //right: 45,
                      left: 20,
                    ),
                    child:
                        isFirstPage //button kiri
                        ? Container(
                            width: 108,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: Color(0xFF1A2A4F),
                                width: 1,
                              ),
                              /*gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF1A2A4F), Color(0xFFF7A5A5)],
                        ),*/
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  if (isFirstPage) {
                                    _controller.animateToPage(
                                      2,
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    _controller.previousPage(
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 6,
                                    bottom: 6,
                                    left: 14,
                                    right: 14,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Lewati',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1A2A4F),
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0xFF1A2A4F), Color(0xFFF7A5A5)],
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  if (isFirstPage) {
                                    _controller.animateToPage(
                                      2,
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    _controller.previousPage(
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },

                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 6,
                                    bottom: 6,
                                    left: 14,
                                    right: 14,
                                  ),
                                  child: Center(
                                    child: Image.asset('assets/arrow.png'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),

                  Row(
                    //dot
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? Color(0xFF1A2A4F)
                              : Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                      //left: 45,
                    ),
                    child: isLastPage
                        ? Container(
                            //button kanan
                            width: 108,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0xFF1A2A4F), Color(0xFFF7A5A5)],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DummyPage(),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 6,
                                    bottom: 6,
                                    left: 14,
                                    right: 14,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Mulai',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            //button kanan
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0xFF1A2A4F), Color(0xFFF7A5A5)],
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  _controller.nextPage(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 6,
                                    bottom: 6,
                                    left: 14,
                                    right: 14,
                                  ),
                                  child: Center(child: Image.asset('assets/arrownext.png')),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide({
    required String image,
    required String title,
    required TextSpan subtitle,
  }) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              height: MediaQuery.of(context).size.height * 0.51,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/pattern.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(60),
                  bottomLeft: Radius.circular(60),
                ),
                gradient: LinearGradient(
                  transform: GradientRotation(120),
                  begin: Alignment.topLeft,
                  end: AlignmentGeometry.bottomRight,
                  colors: [Color(0xFF1A2A4F), Color(0xFFDD979B)],
                  stops: [0.0, 1.9],
                ),
              ),

              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: AlignmentGeometry.bottomCenter,
                  child: Image.asset(
                    image,
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 80),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Color(0xFF1A2A4F),
          ),
        ),
        SizedBox(height: 20),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xFF1A2A4F),
            ),
            children: [subtitle],
          ),
        ),
      ],
    );
  }
}
