import 'dart:io';
import 'dart:typed_data';
import 'package:enough_mail/enough_mail.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

String userName = 'pascari.andrei123@gmail.com';
String password = 'hnknvpihwjthbgdk';
String domain = 'gmail.com';
String imapServerHost = 'imap.$domain';
int imapServerPort = 993;
bool isImapServerSecure = true;
String popServerHost = 'pop.$domain';
int popServerPort = 995;
bool isPopServerSecure = true;
String smtpServerHost = 'smtp.$domain';

//Aplicația poate arăta lista de email-uri din cutia poștală cu ajutorul protocolului POP3
Future<void> popExample() async {
  final client = PopClient(isLogEnabled: false);
  try {
    await client.connectToServer("pop.gmail.com", 995, isSecure: true);
    await client.login("pascari.andrei123@gmail.com", "hnknvpihwjthbgdk");
    final status = await client.status();
    var message;
    for (var i = status.numberOfMessages - 20; i <= status.numberOfMessages; i++) {
      message = await client.retrieve(i);
      printMessage(message);
    }
    await client.quit();
  } on PopException catch (e) {
    print('POP failed with $e');
  }
}

//Aplicația poate arăta lista de email-uri din cutia poștală cu ajutorul protocolului IMAP - 2
Future<void> imapExample() async {
  final client = ImapClient(isLogEnabled: true);
  try {
    await client.connectToServer("imap.gmail.com", 993, isSecure: isImapServerSecure);
    await client.login("pascari.andrei123@gmail.com", "hnknvpihwjthbgdk");
    final mailboxes = await client.listMailboxes();
    print('mailboxes: $mailboxes');
    await client.selectInbox();
    final fetchResult = await client.fetchRecentMessages(messageCount: 2, criteria: 'BODY.PEEK[]');
    for (final message in fetchResult.messages) {
      printMessage(message);
    }
    await client.logout();
  } on ImapException catch (e) {
    print('IMAP failed with $e');
  }
}

MimeMessage buildMessage() {
  final builder = MessageBuilder.prepareMultipartAlternativeMessage(
    plainText: 'Lab5',
    htmlText: '<p>Lab5</p>',
  )
    ..from = [MailAddress('Pascari Andrei', 'pascari.andrei123@gmail.com')]
    ..to = [MailAddress('Other Recipient', 'andrei.pascari@isa.utm.md')]
    ..replyToSimplifyReferences
    ..subject = 'My first message';
  final file = File.fromUri(Uri.parse('file://C:/pascari_lab4_ts.pdf'));
  builder.addFile(file, MediaSubtype.applicationPdf.mediaType);
  return builder.buildMimeMessage();
}

Future<MimeMessage> buildMessageWithAttachment() async {
  final builder = MessageBuilder()
    ..from = [MailAddress('Pascari Andrei', 'pascari.andrei123@gmail.com')]
    ..cc = [MailAddress('Other Recipient', 'andrei.pascari@isa.utm.md')]
    ..to = [
      MailAddress('Pascari Andrei', 'pascari.andrei123@gmail.com'),
      MailAddress('Other Recipient', 'andrei.pascari@isa.utm.md')
    ]

    ..addMultipartAlternative(
      plainText: 'Hello world!',
      htmlText: '<p>Hello world!</p>',
    );
  final file = File.fromUri(Uri.parse('file:C:/pascari_lab4_ts.pdf'));
  await builder.addFile(file, MediaSubtype.applicationPdf.mediaType);
  return builder.buildMimeMessage();
}

Future<void> mailExample() async {
  final email = '$userName';
  print('discovering settings for  $email...');
  final config = await Discover.discover(email);
  if (config == null) {
    print('Unable to auto-discover settings for $email');
    return;
  }
  print('connecting to ${config.displayName}.');
  final account = MailAccount.fromDiscoveredSettings('my account', email, password, config);
  final mailClient = MailClient(account, isLogEnabled: true);
  try {
    await mailClient.connect();
    final mailboxes = await mailClient.listMailboxesAsTree(createIntermediate: false);
    print(mailboxes);
    await mailClient.selectInbox();
    await mailClient.startPolling();
    final mimeMessage = buildMessage();
    await mailClient.sendMessage(mimeMessage);
    buildMessageWithAttachment().then((value) async => await mailClient.sendMessage(value));
  } on MailException catch (e) {
    print('High level API failed with $e');
  }
}

Future<void> printMessage(MimeMessage message) async {
  print('from: ${message.from} with subject "${message.decodeSubject()}"');
  if (!message.isTextPlainMessage()) {
    var info = message.findContentInfo().first;
    var content = message.getPart(info.fetchId);
    var decodedPDF = content!.decodeContentBinary();
    String fileName = 'C:/Users/pasca/Pictures/${info.fileName}.pdf';
    File(fileName).create(recursive: true);
    var myFile = File(fileName);
    await myFile.writeAsBytes(await decodedPDF!);

    print(' scontent-type: ${decodedPDF}sssa ');
  } else {
    final plainText = message.decodeTextPlainPart();
    if (plainText != null) {
      final lines = plainText.split('\r\n');
      for (final line in lines) {
        if (line.startsWith('>')) {
          break;
        }
        print(line);
      }
    }
  }
}

void main() async {
  await mailExample();
  //await popExample();
  // await imapExample();
}
