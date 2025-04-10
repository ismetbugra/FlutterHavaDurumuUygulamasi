import 'package:flutter/material.dart';
import 'package:havadurumu_uygulamasi/models/weather_model.dart';

class DetailScreen extends StatefulWidget {
   DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {


  @override
  Widget build(BuildContext context) {

    final args= ModalRoute.of(context)?.settings.arguments as WeatherModel;
    var iconUrl="https://openweathermap.org/img/wn/${args.weather![0].icon}@2x.png";

    // arka plan fotosu gelen icon codelarına göre düzenlenecek
    String icon="";
    switch(args.weather![0].icon){
      case "01d" || "01n" :
        icon="assets/images/clearsky.jpg";
        break;
      case "02d" || "02n" || "03d" || "03n" || "04d" || "04n" :
        icon="assets/images/parcalibulut2.jpg";
        break;
      case "09d" || "09n" || "10d" || "10n" || "11d" || "11n" :
        icon="assets/images/yagmurlu1.jpg";
        break;
      case "13d" || "13n" :
        icon="assets/images/snow.jpg";
        break;
      case "14d" || "14n" :
        icon="assets/images/sis.jpg";
        break;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Detail"),
      ),
      body: Stack(
        children: [

          SizedBox.expand(
            child: Image.asset(icon,
            fit: BoxFit.cover,),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 8,
                color: Colors.grey.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(args.name!,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8,),

                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.5),
                        radius: 100,
                        child: Image.network(iconUrl),
                      ),

                      Text(args.main!.temp!.round().toString()+"°",
                        style: Theme.of(context).textTheme.headlineLarge ,
                      ),
                      const SizedBox(height: 8,),
                      Text(args.weather![0].description ?? "Değer bulunamadı"),
                      const SizedBox(height: 8,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.water_drop),
                              Text(args.main!.humidity!.toString())
                            ],
                          ),
                          SizedBox(width: 32,),
                          Column(
                            children: [
                              Icon(Icons.air),
                              Text(args.wind!.speed!.round().toString())
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}
