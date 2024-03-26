import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:testing_printer/widgets/alert_dialog_printers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing printer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SAAED PAY - Printer Testing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String? ipAddress;
  String? port;
  String ipV4Pattern = r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$';
  RegExp? ipRegEx;
  String portPattern = r'^(?:[1-9]\d{0,3}|[1-5]\d{4}|6[0-4]\d{3}|65[0-4]\d{2}|655[0-2]\d|6553[0-5])$';
  String response = "";

  RegExp? portRegEx;
  @override
  void didChangeDependencies() {
    ipRegEx = RegExp(ipV4Pattern);
    portRegEx = RegExp(portPattern);

    super.didChangeDependencies();
  }

  void testReceiptWifi(NetworkPrinter printer) {
    printer.text('Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ', styles: const PosStyles(codeTable: 'CP1252'));
    printer.text('Special 2: blåbærgrød', styles: const PosStyles(codeTable: 'CP1252'));

    printer.text('Bold text', styles: const PosStyles(bold: true));
    printer.text('Reverse text', styles: const PosStyles(reverse: true));
    printer.text('Underlined text', styles: const PosStyles(underline: true), linesAfter: 1);
    printer.text('Align left', styles: const PosStyles(align: PosAlign.left));
    printer.text('Align center', styles: const PosStyles(align: PosAlign.center));
    printer.text('Align right', styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

    printer.text('Text size 200%',
        styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    printer.feed(2);
    printer.cut();
  }

  // Ticket testReceiptBluetooth() {
  //   // Ticket is not found we can use traditional bytes printing method
  //   final Ticket ticket = Ticket(PaperSize.mm80);

  //   ticket.text('Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
  //   ticket.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ', styles: PosStyles(codeTable: PosCodeTable.westEur));
  //   ticket.text('Special 2: blåbærgrød', styles: PosStyles(codeTable: PosCodeTable.westEur));

  //   ticket.text('Bold text', styles: PosStyles(bold: true));
  //   ticket.text('Reverse text', styles: PosStyles(reverse: true));
  //   ticket.text('Underlined text', styles: PosStyles(underline: true), linesAfter: 1);
  //   ticket.text('Align left', styles: PosStyles(align: PosAlign.left));
  //   ticket.text('Align center', styles: PosStyles(align: PosAlign.center));
  //   ticket.text('Align right', styles: PosStyles(align: PosAlign.right), linesAfter: 1);

  //   ticket.text('Text size 200%',
  //       styles: PosStyles(
  //         height: PosTextSize.size2,
  //         width: PosTextSize.size2,
  //       ));

  //   ticket.feed(2);
  //   ticket.cut();
  //   return ticket;
  // }

  _showBluetoothPrinters() async {
    await showDialog(context: context, builder: (_) => AlertDialogPrinters());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(190, 150, 85, 1),
        title: FittedBox(child: Text(widget.title, style: const TextStyle(color: Colors.white))),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * .2,
                        child: Center(child: Text(response, style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black)))),
                    const Text("IP ADDRESS:"),
                    TextFormField(
                      key: const ValueKey("ip-address"),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) => ipAddress = value,
                      validator: (value) => ipRegEx!.hasMatch(value!) ? null : "Please type a valide IPV4 address",
                      onSaved: (newValue) {
                        ipAddress = newValue;
                        debugPrint("ipAddress:" + ipAddress!);
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text("PORT(9100):"),
                    TextFormField(
                      key: const ValueKey("port"),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) => port = value,
                      validator: (value) => portRegEx!.hasMatch(value!) ? null : "Please type a valide PORT number",
                      onSaved: (newValue) {
                        port = newValue;
                        print("prot:" + port!);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: _isLoading
          ? const CircularProgressIndicator()
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    final isValid = _formKey.currentState!.validate();
                    print("isValid:" + isValid.toString());
                    if (isValid) {
                      print("port:" + port! + " ip:" + ipAddress!);
                      _formKey.currentState!.save();
                      setState(() {
                        _isLoading = true;
                      });
                      const PaperSize paper = PaperSize.mm80;
                      final profile = await CapabilityProfile.load();
                      final printer = NetworkPrinter(paper, profile);
                      // final PosPrintResult res = await printer.connect('192.168.0.123', port: 9100);
                      final PosPrintResult res = await printer.connect(ipAddress!, port: int.parse(port!), timeout: Duration(seconds: 10));
                      if (res == PosPrintResult.success) {
                        testReceiptWifi(printer);
                        printer.disconnect();
                        setState(() {
                          response = "printing....";
                          _isLoading = false;
                        });
                      } else {
                        debugPrint('Print result: ${res.msg}');
                        setState(() {
                          response = res.msg;
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  tooltip: 'Print',
                  child: const Column(
                    children: [
                      Icon(Icons.wifi, color: Colors.blue),
                      Icon(Icons.print, color: Colors.blue),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                FloatingActionButton(
                  backgroundColor: Colors.blue[900],
                  onPressed: () async {
                    _showBluetoothPrinters();
                  },
                  tooltip: 'Print',
                  child: const Column(
                    children: [
                      Icon(Icons.bluetooth, color: Colors.white),
                      Icon(Icons.print, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
