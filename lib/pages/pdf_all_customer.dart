import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:makb_admin_pannel/data_model/dart/customer_data_model.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:makb_admin_pannel/widgets/fading_circle.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:convert';
import 'dart:html'as html;


class AllCustomerPDF{

  static Future<void> allCustomerPdf(List<UserModel> dataList, String title,BuildContext context,PublicProvider publicProvider)async{
    showLoaderDialog(context);
    final pdf = pw.Document();
    var data = await rootBundle.load("assets/font/OpenSans-Regular.ttf");
    var myFont = pw.Font.ttf(data);
    var boldTextStyle = pw.TextStyle(
      font: myFont,
      fontSize: 11.0,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.black,
    );
    var normalTextStyle = pw.TextStyle(
        font: myFont,
        fontSize: 8.0,
        fontWeight: pw.FontWeight.normal,
        color: PdfColors.black
    );

    pdf.addPage(
      pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(32),
          build: (pw.Context context){
            return[
              pw.Header(
                //level: 0,
                child: pw.Text(title,textAlign:pw.TextAlign.center,style: boldTextStyle),
              ),
              ///Table Header
              pw.Row(
                  children: [
                    pw.Expanded(
                        child: pw.Container(
                            alignment: pw.Alignment.center,
                            width: 272,
                            child: pw.Text(
                                'ID',
                                textAlign: pw.TextAlign.center,
                                style: normalTextStyle
                            )
                        )
                    ),

                    pw.Expanded(
                        child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                                'Name',
                                textAlign: pw.TextAlign.center,
                                style: normalTextStyle
                            )
                        )
                    ),
                    pw.Expanded(
                        child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                                'Info',
                                textAlign: pw.TextAlign.center,
                                style: normalTextStyle
                            )
                        )
                    ),
                    pw.Expanded(
                        child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                                'Refer',
                                textAlign: pw.TextAlign.center,
                                style: normalTextStyle
                            )
                        )
                    ),
                    pw.Expanded(
                        child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                                'Level',
                                textAlign: pw.TextAlign.center,
                                style: normalTextStyle
                            )
                        )
                    ),
                    pw.Expanded(
                        child: pw.Container(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                                'Balance',
                                textAlign: pw.TextAlign.center,
                                style: normalTextStyle
                            )
                        )
                    ),
                  ]
              ),
              pw.Divider(color: PdfColors.grey900,height: 5.0),
              pw.SizedBox(height: 10.0),

              pw.ListView.builder(
                  itemCount:dataList.length,
                  itemBuilder: (context, index){
                    return pw.Column(
                        children:[
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Expanded(
                                    child: pw.Container(
                                      alignment: pw.Alignment.center,
                                      child: pw.Text(
                                          '${dataList[index].id}',
                                          textAlign: pw.TextAlign.center,
                                          style: normalTextStyle
                                      ),
                                    )
                                ),

                                pw.Expanded(
                                    child: pw.Container(
                                      alignment: pw.Alignment.center,
                                      child: pw.Text(
                                          dataList[index].name!,
                                          textAlign: pw.TextAlign.center,
                                          style: normalTextStyle
                                      ),
                                    )
                                ),pw.Expanded(
                                    child: pw.Container(
                                      alignment: pw.Alignment.center,
                                      child: pw.Text(
                                          '${dataList[index].address!} \n ${dataList[index].email!} \n${dataList[index].phone!} ' ,
                                          textAlign: pw.TextAlign.center,
                                          style: normalTextStyle
                                      ),
                                    )
                                ),pw.Expanded(
                                    child: pw.Container(
                                      alignment: pw.Alignment.center,
                                      child: pw.Text(
                                          dataList[index].numberOfReferred!,
                                          textAlign: pw.TextAlign.center,
                                          style: normalTextStyle
                                      ),
                                    )
                                ),
                                pw.Expanded(
                                  child: pw.Container(
                                    alignment: pw.Alignment.center,
                                    child: pw.Text(
                                        dataList[index].level!,
                                        textAlign: pw.TextAlign.center,
                                        style: normalTextStyle
                                    ),
                                  )
                                ),
                                pw.Expanded(
                                    child: pw.Container(
                                      alignment: pw.Alignment.center,
                                      child: pw.Text(
                                          dataList[index].mainBalance!,
                                          textAlign: pw.TextAlign.center,
                                          style: normalTextStyle
                                      ),
                                    )
                                ),

                              ]
                          ),
                          pw.Divider(height: 0.0,thickness: 0.5,color: PdfColors.grey)
                        ]
                    );
                  }
              ),
            ];
          }
        //maxPages: 100
      ),
    );
    Uint8List pdfInBytes = await pdf.save();
    html.AnchorElement(
        href:
        "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(pdfInBytes)}")
      ..setAttribute("download", "output.pdf")
      ..click();

    Navigator.pop(context);
    //Navigator.pop(context);
    publicProvider.category=publicProvider.subCategory;
    publicProvider.subCategory='Customer';

  }

}
