import 'package:flutter/material.dart';

class ReglamentoForm extends StatelessWidget {
  const ReglamentoForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Card(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 15),
              _textTitle("REGLAMENTO GENERAL"),
              const SizedBox(height: 5),
              _textTitle("PARA EL USO Y DISFRUTE DEL PARQUE OFFROAD"),
              const SizedBox(height: 5),
              _textTitle("SANTIAGO 4X4 PRO"),
              const SizedBox(height: 15),
              _textContent("Con el fin de asegurar el sano entretenimiento y la mayor seguridad a sus huéspedes, en un ambiente familiar, Parque Offroad “Santiago 4x4 Pro” pone en conocimiento a sus socios y al público en general, de las siguientes regulaciones: "),
              const SizedBox(height: 15),
              _textTitle("-	USO DE INSTALACIONES "),
              const SizedBox(height: 5),
              _textContent("1.	Parque Offroad es propiedad privada. Parque Offroad Santiago 4x4 Pro se reserva el derecho de no permitir el ingreso y/o la admisión de usuarios a sus instalaciones."),
              const SizedBox(height: 5),
              _textContent("2.	Todo usuario deberá respetar las instrucciones escritas o verbales que se hagan oportunamente dentro de Parque Offroad, en sus instalaciones generales o bien para el uso de alguna pista en específica."),
              const SizedBox(height: 5),
              _textContent("3.	Las instalaciones y atracciones de Parque Offroad son para el disfrute y entretenimiento de sus socios y usuarios. Cualquier daño a la propiedad, a las instalaciones, personal, edificios, juegos, atracciones, etc. será sancionada como corresponda. "),
              const SizedBox(height: 5),
              _textContent("4.	Cualquier actividad privada, sea comercial, proselitista, de comunicación, anuncios, promoción, etc., que no esté previamente autorizada o supervisada por Parque Offroad “Santiago 4x4 Pro”, está prohibida. Así, no se permitirán ventas ambulantes, repartición de volantes, contacto no autorizado verbal o escrito con los usuarios, dentro de las instalaciones ni tampoco la solicitud de limosnas o ayudas monetarias. "),
              const SizedBox(height: 5),
              _textContent("5.	Para la adquisición de membresía anual renta de espacio para acampar o evento privado, Parque Offroad “Santiago 4x4 Pro” se reserva el derecho de requerir documentos de identificación para su revisión. Igualmente, podrá retener los mismos como depósito de garantía o bien recibir un depósito en monetario. "),
              const SizedBox(height: 5),
              _textContent("6.	Se prohíbe realizar fiestas no autorizadas por la administración de Parque Offroad “Santiago 4x4 Pro”."),
              const SizedBox(height: 5),
              _textContent("7.	No se permite que los socios o usuarios coloquen tiendas de campaña, hamacas y/u otros artículos similares dentro de las instalaciones sin previo aviso.  Parque Offroad “Santiago 4x4 Pro” se reserva el derecho de remover cualquier artículo colocado sin autorización. "),
              const SizedBox(height: 15),
              _textTitle("-	COMPORTAMIENTO DE HUESPEDES "),
              const SizedBox(height: 5),
              _textContent("8.	Los Socios y usuarios deberán conducirse dentro de las instalaciones con decoro y respeto. No se permite conductas impropias, inmorales o que afecten la tranquilidad, la paz y seguridad de los socios y/o usuarios en Parque Offroad “Santiago 4x4 Pro”.  "),
              const SizedBox(height: 5),
              _textContent("9.	El tránsito en las instalaciones con animales está permitido solo para mascotas con su debida correa, con el fin de evitar el estress de los mismos por el ruido de los motores."),
              const SizedBox(height: 5),
              _textContent("10.	Se permite tomar fotos y videos para usos personales y recreativos que sean recuerdo del día de la visita a Parque Offroad “Santiago 4x4 Pro”, siempre y cuando no incomode la privacidad e intimidad de terceras personas. Está prohibido tomar fotos y/o videos para usos profesionales y/o de carácter comercial que no estén autorizados previamente por Parque Offroad “Santiago 4x4 Pro”. "),
              const SizedBox(height: 15),
              _textTitle("- COMIDAS Y BEBIDAS "),
              const SizedBox(height: 5),
              _textContent("11.	Se permite el ingreso con comidas preparadas que podrán ser ingeridas únicamente en áreas autorizadas para ello (“Pic-Nic”), las cuales se encuentran debidamente rotuladas. "),
              const SizedBox(height: 5),
              _textContent("12.	Por seguridad de los huéspedes solo se permite asadores o preparación de alimentos en las áreas Sociales (Palapas) quedando prohibido el uso de fogatas y/o asadores en el interior de la pista de Parque Offroad “Santiago 4x4 Pro”. "),
              const SizedBox(height: 5),
              _textContent("13.	No se permite el uso de drogas, o cualquier otra sustancia equivalente, o transitar dentro de Parque Offroad “Santiago 4x4 Pro” en estado de ebriedad o drogado, lo cual podrá ser valorado discrecionalmente por las autoridades correspondientes de Parque.  Se exceptúa el consumo moderado de bebidas alcohólicas en áreas designadas."),
              const SizedBox(height: 15),
              _textTitle("-	HIGIENE, LIMPIEZA Y ORDEN "),
              const SizedBox(height: 5),
              _textContent("14.	La basura y residuos de cualquier clase deberá depositarse en los contenedores destinados como basureros. "),
              const SizedBox(height: 5),
              _textContent("15.	No se permite la sustracción o daño de animales, plantas y/o zonas verdes. "),
              const SizedBox(height: 15),
              _textTitle("-	USO DE ATRACCIONES "),
              const SizedBox(height: 5),
              _textContent("16.	El brazalete de autorización para uso de pista es personal. No se permite trasladarlo de una persona a otra. "),
              const SizedBox(height: 5),
              _textContent("17.	El brazalete podrá ser sustituido únicamente por deterioro visible y contra la entrega del dañado. "),
              const SizedBox(height: 5),
              _textContent("18.	Por seguridad no se permite el uso de las instalaciones a vehículos con visibles fallas mecánicas o que no cuenten con elementos de seguridad (cinturones, jaula antivuelco o techo de lámina, puntos de arrastre). "),
              const SizedBox(height: 5),
              _textContent("19.	Por seguridad Parque Offroad “Santiago 4x4 Pro” tiene trazado y señalizado un recorrido el cual cuenta con escapes para utilizarse por usuarios con menos experiencia o vehículos con menos equipo. Si no te sientes preparado para sortear un obstáculo busca los escapes y no te arriesgues."),
              const SizedBox(height: 5),
              _textContent("20.	En caso de cierre de pista por causa de fuerza mayor se dará un reembolso o una cortesía para utilizarse en otra ocasión."),
              const SizedBox(height: 5),
              _textContent("21.	El ingreso a las pistas deberá ser en orden y respetando la fila correspondiente.  Las pistas operarán hasta la hora de cierre de Parque Offroad “Santiago 4x4 Pro”, posterior a la hora de cierre el operador procede a cerrar el acceso, permitiendo el uso únicamente a los socios o usuarios que aún siguen en recorrido."),
              const SizedBox(height: 5),
              _textContent("22.	Clientes de Eventos y Fiestas de Cumpleaños deberán cumplir el mismo reglamento, así como turnos de uso de pistas. "),
              const SizedBox(height: 5),
              _textContent("23.	Personas con discapacidad y adulto mayor tienen prioridad en áreas sociales, bajo las condiciones y regulaciones establecidas por la administración de Parque Offroad “Santiago 4x4 Pro”. "),
              const SizedBox(height: 5),
              _textContent("24.	Las pistas o caminos en Mantenimiento o uso Preventivo se indican en la Entrada Principal. "),
              const SizedBox(height: 5),
              _textContent("25.	Durante algunas ocasiones, ciertas pistas o recorridos cesaran su funcionamiento debido a eventos o actividades especiales. "),
              const SizedBox(height: 5),
              _textContent("26.	Se prohíbe el uso de vehículos a aquellos socios o usuarios con alguna discapacidad o incapacidad temporal o permanente, que puedo poner en riesgo su integridad o la de los demás usuarios. "),
              const SizedBox(height: 15),
              _textTitle("-	MEDIDAS DE SEGURIDAD PERSONAL "),
              const SizedBox(height: 5),
              _textContent("27.	Parque Offroad “Santiago 4x4 Pro” NO cuenta con personal de seguridad interna, acatemos este reglamento y evitemos incidentes. "),
              const SizedBox(height: 5),
              _textContent("28.	No se permite portar y/o usar armas de fuego o punzo cortantes o de cualquier otro tipo, dentro de las instalaciones. Al ingresar a Parque Offroad “Santiago 4x4 Pro” éstas y cualquier otro tipo de armas deberán ser reportadas y retenidas por el staff. "),
              const SizedBox(height: 15),
              _textTitle("-	OBJETOS DESATENDIDOS O PERDIDOS "),
              const SizedBox(height: 5),
              _textContent("29.	Parque Offroad “Santiago 4x4 Pro” no se responsabilizará por objetos desatendidos o perdidos dentro de las instalaciones. "),
              const SizedBox(height: 5),
              _textContent("30.	Por razones de seguridad, Parque Offroad “Santiago 4x4 Pro” se reserva el derecho de retirar de las instalaciones todo objeto desatendido que no sea reclamado por su propietario. "),
              const SizedBox(height: 5),
              _textContent("31.	En caso de que un vehículo sufra una avería que impida su funcionamiento, es obligación del propietario dar informe al personal de la pista."),
              const SizedBox(height: 5),
              _textContent("32.	No obstante, Parque Offroad “Santiago 4x4 Pro” cuenta con un centro de “Perdido y Encontrado” ubicado en la taquilla. "),
              const SizedBox(height: 15),
              _textTitle("-	PROMOCIONES Y CORTESIAS INTERNAS "),
              const SizedBox(height: 5),
              _textContent("33.	Toda promoción está sujeta a restricciones, las cuales serán comunicadas oportunamente. "),
              const SizedBox(height: 5),
              _textContent("34.	Pases Especiales de cortesía, otorgados según reglamento interno, no son negociables o canjeables. "),
              const SizedBox(height: 15),
              _textTitle("-	ACCIDENTES Y SINIESTROS "),
              const SizedBox(height: 5),
              _textContent("35.	Todo huésped será responsable del uso que haga de las instalaciones y pistas de obstáculos de Parque Offroad “Santiago 4x4 Pro”, considerando sus limitaciones físicas y de salud. "),
              const SizedBox(height: 15),
              _textTitle("-	CUMPLIMIENTO DE REGULACIONES  "),
              const SizedBox(height: 5),
              _textContent("36.	Todo Socio y/o usuario, sin excepción, deberá cumplir y respetar las reglamentaciones, restricciones, instrucciones, etc. adoptadas por Parque Offroad “Santiago 4x4 Pro” en conjunto con criterios y principios sobre salubridad, seguridad, orden, y la legislación costarricense aplicable.  "),
              const SizedBox(height: 5),
              _textContent("37.	Toda persona ingresa a Parque Offroad “Santiago 4x4 Pro” bajo su riesgo y responsabilidad. Todo niño o menor de edad se entiende ha ingresado a Parque Offroad “Santiago 4x4 Pro”con la autorización, consentimiento, supervisión, cuido, y bajo responsabilidad de su guardián, padre o persona mayor de edad a cargo.  "),
              const SizedBox(height: 5),
              _textContent("38.	Parque Offroad “Santiago 4x4 Pro” aplicará y ejecutará estas instrucciones en conjunto con los términos y disposiciones de reglamentos internos aplicables; criterios y principios sobre salubridad, seguridad, orden; y la legislación costarricense aplicable. Los funcionarios designados para estos fines decidirán si se ha violado cualquiera de dichas instrucciones y a su discreción podrá llamar la atención a los socios y/o usuarios para corregir su comportamiento o solicitarles abandonar las instalaciones de Parque Offroad “Santiago 4x4 Pro”, solicitud que deberá ser debidamente acatada. En estos casos no se reembolsará cualquier pase de ingreso pagado.  "),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

}

Widget _textTitle(String text) {
  return Center(
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20.0
      ),
    ),
  );
}

Widget _textContent(String text) {
  return SizedBox(
    width: 300.0,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.bold,
        fontSize: 12.0
      ),
      textAlign: TextAlign.justify,
    ),
  );
}