import 'package:bicicorunha/model/Bicicletas.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../model/StationEntera.dart';

class DetalleViewModel {

Future<void> generarPdf(Stationentera estacion) async {
  final pdf = pw.Document();

  final fechaGeneracion = DateTime.now();
  final fechaActualizacion = estacion.estado.fechaActualizacion;

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Informe de la estación: ${estacion.info.nombre}',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Dirección: ${estacion.info.direccion}'),
            pw.Text('Estado actual: ${estacion.estado.estadoEstacion}'),
            pw.Text(
                'Fecha de actualización de los datos: ${DateFormat('yyyy-MM-dd HH:mm').format(fechaActualizacion)}'),
            pw.Text(
                'Fecha de generación del PDF: ${DateFormat('yyyy-MM-dd HH:mm').format(fechaGeneracion)}'),
            pw.SizedBox(height: 20),
            pw.Text('Bicicletas disponibles:'),
            pw.Bullet(text: 'E-bikes: ${estacion.estado.tiposBicicletas.firstWhere((b) => b.tipo == "EFIT", orElse: () => Bicicletas(tipo: "EFIT", cantidad: 0)).cantidad}'),
            pw.Bullet(text: 'Mecánicas: ${estacion.estado.tiposBicicletas.firstWhere((b) => b.tipo == "FIT", orElse: () => Bicicletas(tipo: "FIT", cantidad: 0)).cantidad}'),
            pw.Bullet(text: 'Huecos libres: ${estacion.estado.huecosLibres}'),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

}
