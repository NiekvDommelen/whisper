import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Whisper",
            style: GoogleFonts.jura(
                textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.w800))),
      ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  width: screenWidth - 20,
                  height: 60,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text("N",
                            style: GoogleFonts.jura(
                                textStyle: TextStyle(
                                    color:
                                    Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth - 140,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("Niek",
                                    style: GoogleFonts.jura(
                                        textStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800))),
                                Text(
                                  "chat message go brrrrrrrbr",
                                  style: GoogleFonts.jura(
                                      textStyle:
                                      TextStyle(color: Colors.white70),
                                      fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 35,
                            alignment: Alignment.topCenter,
                            child: Text("9:49",
                                style: GoogleFonts.jura(
                                    textStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800))),
                          )
                        ],
                      )
                    ],
                  ))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  width: screenWidth - 20,
                  height: 60,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text("N",
                            style: GoogleFonts.jura(
                                textStyle: TextStyle(
                                    color:
                                    Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth - 140,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("Niek",
                                    style: GoogleFonts.jura(
                                        textStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800))),
                                Text(
                                  "chat message go brrrrrrrrrrrr",
                                  style: GoogleFonts.jura(
                                      textStyle:
                                      TextStyle(color: Colors.white70),
                                      fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 35,
                            alignment: Alignment.topCenter,
                            child: Text("9:49",
                                style: GoogleFonts.jura(
                                    textStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800))),
                          )
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ],
      ),
    );
  }
}