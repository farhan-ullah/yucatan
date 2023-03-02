import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../theme/custom_theme.dart';
import '../../utils/widget_dimensions.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({Key? key}) : super(key: key);

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  final List<String> language = ['English', 'Spanish'];
  var selectedValue = 'English';
  var initialIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Dimensions.pixels_18,
                ),
                Text(
                  'Welcome to AppVenture Demo.',
                  style: TextStyle(
                      fontSize: Dimensions.getScaledSize(17.0),
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                SizedBox(
                  height: Dimensions.pixels_18,
                ),
                const Text(
                  'We will give you a concrete preview of the app for your destination within seconds.\nPlease share the below requsted information.',
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Wrap(
                    children: List.generate(
                        3,
                        (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 13,
                                width: 100,
                                color: index == initialIndex
                                    ? Colors.blueAccent
                                    : Colors.grey,
                              ),
                            )),
                  ),
                ),
              ],
            ),
            initialIndex == 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Let us know your configurations'),
                        buildSizedBox(Dimensions.pixels_50),
                        const Text(
                          'Please upload your logo',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(4),
                              // color: Colors.pink,
                              border: Border(
                                top: BorderSide(
                                    width: 1.0, color: Colors.grey.shade600),
                                bottom: const BorderSide(
                                    width: 1.0, color: Colors.black),
                                left: const BorderSide(
                                    width: 1.0, color: Colors.black),
                                right: const BorderSide(
                                    width: 1.0, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        buildSizedBox(Dimensions.pixels_20),
                        const Text(
                          'Please tell us your primary colors',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(4),
                              // color: Colors.pink,
                              border: Border(
                                top: BorderSide(
                                    width: 1.0, color: Colors.grey.shade600),
                                bottom: const BorderSide(
                                    width: 1.0, color: Colors.black),
                                left: const BorderSide(
                                    width: 1.0, color: Colors.black),
                                right: const BorderSide(
                                    width: 1.0, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        buildSizedBox(Dimensions.pixels_20),
                        const Text(
                          'Please tell us your secondary colors',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(4),
                              // color: Colors.pink,
                              border: Border(
                                top: BorderSide(
                                    width: 1.0, color: Colors.grey.shade600),
                                bottom: const BorderSide(
                                    width: 1.0, color: Colors.black),
                                left: const BorderSide(
                                    width: 1.0, color: Colors.black),
                                right: const BorderSide(
                                    width: 1.0, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        buildSizedBox(Dimensions.pixels_20),
                        const Text(
                          'In which language you want to preview the app?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13.0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            child: Center(
                              child: DropdownButton<String>(
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  size: 35,
                                ),
                                underline: const SizedBox(),
                                isExpanded: true,
                                isDense: true,
                                value: selectedValue,
                                items: language.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : initialIndex == 1
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildSizedBox(Dimensions.pixels_30),
                            const Text('Contact information'),
                            buildSizedBox(Dimensions.pixels_30),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        hintText:'Firstname',
                                        // AppLocalizations.of(context)!
                                        //     .forgotPasswordScreen_emailHint,
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                        )),
                                    // controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                                SizedBox(width: Dimensions.pixels_30,),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        hintText:'Lastname',
                                        // AppLocalizations.of(context)!
                                        //     .forgotPasswordScreen_emailHint,
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                        )),
                                    // controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              ],
                            ),
                            buildSizedBox(Dimensions.pixels_30),
                            TextField(
                              decoration: InputDecoration(
                                  hintText:'Organization',
                                  // AppLocalizations.of(context)!
                                  //     .forgotPasswordScreen_emailHint,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                  )),
                              // controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            buildSizedBox(Dimensions.pixels_30),
                            TextField(
                              decoration: InputDecoration(
                                  hintText:'E-mail-address',
                                  // AppLocalizations.of(context)!
                                  //     .forgotPasswordScreen_emailHint,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                  )),
                              // controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            buildSizedBox(Dimensions.pixels_30),
                            TextField(
                              decoration: InputDecoration(
                                  hintText:'Phone No.',
                                  // AppLocalizations.of(context)!
                                  //     .forgotPasswordScreen_emailHint,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                  )),
                              // controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
            buildSizedBox(Dimensions.pixels_20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    minimumSize: Size(
                        MediaQuery.of(context).size.width, 40), //////// HERE
                  ),
                  onPressed: () {
                    setState(() {
                      initialIndex++;
                      print(initialIndex);
                    });
                  },
                  child: initialIndex == 0? Text('Confirm and go to next step'): initialIndex == 1? Text('Confirm and see app emulatio'): Text('')
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buildSizedBox(double pixelValue) {
    return SizedBox(
      height: pixelValue,
    );
  }
}
