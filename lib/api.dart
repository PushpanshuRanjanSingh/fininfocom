// import 'dart:io';

// import 'package:fininfocom/constant/assets.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:wechat_assets_picker/wechat_assets_picker.dart';

// submitLoadInvoiceApi(imgFileList) async {
//   String keyAPI =
//       "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYTc4NTMyNGVjZDFlOGNiOGZmZGQ5YjRlYzIwMGNmMGE0ZTcxM2U3MmNjZmIxNjAzNzFjZTVmM2JmMTlkYjYyOGM3NDY5NTQyNjkxNDY2ZWQiLCJpYXQiOjE2Nzg5ODMxMTcuODU2Nzc1LCJuYmYiOjE2Nzg5ODMxMTcuODU2Nzc3LCJleHAiOjE3MTA2MDU1MTcuODUwODg0LCJzdWIiOiIzNTgiLCJzY29wZXMiOltdfQ.C_iE4Z_TteBFijQT-XkwSYbPotRzZbq8zncqeni-CggQVJeRNZ_O8IjsRrJxAdfAwtYhMxsit-Sh8WePdM9e_s0KNdMMWxUd-cbdQ0LECW817GKxC-i4ESSd7U9aRdIlOM8gkcNv7MXcBtRj2PCkclSR1jXD7Viq9J67jEvaGxGxK_XNoPaK5RhItKcE23GMRwvw-eKUVBXBdR8M1WdZa361u8R5yC7EEngJXjkZ4-dRQ_-RCrSUbhPf_vdv-mQImaAeVPtpB45leGW6NXMA5kEMii_l_RrHQ83TlPfanZ_ukWsWDvogmHPUNieFOH7sDvYKZ4eDyLcM8R3xcHEiR9twoWwZYwFJJmL8jgM_oGYeXYsoG-w6wamZIKa-epXZ7Mrm4PpWfzjKXoBjMS_6Ky7kB7UUI6l92voCAat_W8MKLJoj-w7Xfw57jOMju-tyt6vflJKFNEoQUiQykK9fjzevDxXNnxTlLw99DRfaFXVh025OBIH0zYgRFXrOg0-ZFRb6uTlNJiwQTbaA37iNsuZMaLrxTbKCrgGPda4YwLmjvCiFdk29EeUELA0vNwtndFnGF4jXQmm9HR9aigtv6ooWIYZRsTs7XyE3LoReS9Vw2ekOAwQLDULPBoN57tTIo1sNd5ohDHYT7rLQHpqCYgrJWUDISONPwUOtswaPk7g";
//   try {
//     var headers = {'Authorization': "Bearer $keyAPI"};
//     var request = http.MultipartRequest(
//         'POST', Uri.parse('http://staging.cadencecash.com/api/addLoad'));
//     request.fields.addAll({
//       'user_id': '358',
//       'load_number': '324',
//       'shipper_name': 'hsdf',
//       'invoice_amount': '43',
//       'shipper_email': 'dffd@yopmail.com',
//       'shipper_contact': '6754334678',
//       'freight_rate': '1',
//       'fuel_surcharge': '12',
//       'toll_charges': '213',
//       'accessorialData[]': '{"description": "taire","amount": 23}',
//       'load_id': ''
//     });
//     request.files.add(await multipartFileFromAssetEntity(imgFileList));

//     request.headers.addAll(headers);
//     request.send().then((result) {
//       http.Response.fromStream(result).then((response) {
//         if (response.statusCode == 200) {
//           debugPrint(response.body.toString());
//         }
//       });
//     });
//   } catch (e) {
//     debugPrint("Error Anythings: $e");
//   }
// }

// Future<http.MultipartFile> multipartFileFromAssetEntity(
//     AssetEntity entity) async {
//   http.MultipartFile mf;
//   // Using the file path.
//   final file = await entity.file;
//   if (file == null) {
//     throw StateError('Unable to obtain file of the entity ${entity.id}.');
//   }
//   mf = await http.MultipartFile.fromPath('imageData', file.path);
//   // Using the bytes.
//   final bytes = await entity.originBytes;
//   if (bytes == null) {
//     throw StateError('Unable to obtain bytes of the entity ${entity.id}.');
//   }
//   mf = http.MultipartFile.fromBytes('imageData', bytes);
//   return mf;
// }
