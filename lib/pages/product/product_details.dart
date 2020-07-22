import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:realestate/I10n/app_localizations.dart';
import 'package:realestate/models/product_model.dart';
import 'package:realestate/services/get_product.dart';

class ProductDetails extends StatefulWidget {
  int productId;

  ProductDetails(this.productId);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List<String> imgList;
  List child;
  int _current = 0;
  ProductModel productModel;
  bool isLoading = true;

  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  CameraPosition _kGooglePlex;


  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  getProductDetails() async {
    productModel = await GetProduct().getProduct(widget.productId);
    List<String> photos = List<String>();
    productModel.photosList.forEach((element) {
      photos.add(element.photo);
    });
    initPhotos(photos);
    _kGooglePlex = CameraPosition(
      target: LatLng(productModel.latitude, productModel.longitude),
      zoom: 14.4746,
    );


    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId("currentState"),
      position: LatLng(productModel.latitude, productModel.longitude),
      infoWindow: InfoWindow(
        // title is the address
        title: "${productModel.title}",
        // snippet are the coordinates of the position
        snippet: 'Lat: ${productModel.latitude}, Lng: ${productModel
            .longitude}',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));

    isLoading = false;
    setState(() {});
  }

  initPhotos(List<String> photos) {
    imgList = photos;
    photoSlider();
  }

  photoSlider() {
    child = map<Widget>(
      imgList,
          (index, i) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Image.network(i, fit: BoxFit.cover, width: 1000.0),
          ),
        );
      },
    ).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('category name'),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              Icons.star_border,
              color: Color(0xFFF99743),
            ),
          )
        ],
      ),
      body: Scaffold(
        body: isLoading ? Center(child: CircularProgressIndicator(),) :
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CarouselSlider(
                items: child,
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                      print('in the slider $_current');
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(
                  imgList,
                      (index, url) {
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 5.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index ? Color(0xFF0D986A) : Color(
                              0xFFD8D8D8)),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "${productModel.price} ريال ",
                          style: TextStyle(color: Color(0xFF0D986A)),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "${productModel.date}",
                              style: TextStyle(color: Color(0xFFACB1C0)),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFB151),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/icons/pin.png',
                            scale: 4,
                            color: Color(0xFFF99743),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                          ),
                          Text(
                            '${productModel.address}',
                            style: TextStyle(color: Color(0xFFACB1C0)),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF4F5F8),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.asset(
                                'assets/icons/roomArea.png',
                                scale: 4,
                                color: Color(0xFFF99743),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                              ),
                              Text('${AppLocalizations.of(context).translate('area')}')
                            ],
                          ),
                          Text("${productModel.area} متر ")
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image.asset(
                                  'assets/icons/compass.png',
                                  scale: 4,
                                  color: Color(0xFFF99743),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                ),
                                Text('${AppLocalizations.of(context).translate(
                                    'front')}')
                              ],
                            ),
                            Text("${productModel.facadeName}"),
                          ],
                        )),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF4F5F8),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.asset(
                                'assets/icons/bed.png',
                                scale: 4,
                                color: Color(0xFFF99743),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                              ),
                              Text('${AppLocalizations.of(context).translate('bedroomNumber')}')
                            ],
                          ),
                          Text("${productModel.numberOfRooms}")
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image.asset(
                                  'assets/icons/bath.png',
                                  scale: 4,
                                  color: Color(0xFFF99743),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                ),
                                Text('${AppLocalizations.of(context).translate(
                                    'bathroomNumber')}')
                              ],
                            ),
                            Text("${productModel.numberOfBathRooms}"),
                          ],
                        )),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF4F5F8),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.asset(
                                'assets/icons/sofa.png',
                                scale: 4,
                                color: Color(0xFFF99743),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                              ),
                              Text('${AppLocalizations.of(context).translate('lounges')}')
                            ],
                          ),
                          Text("${productModel.numberOfLivingRooms}")
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image.asset(
                                  'assets/icons/street.png',
                                  scale: 4,
                                  color: Color(0xFFF99743),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                ),
                                Text('${AppLocalizations.of(context).translate(
                                    'streetWidth')}')
                              ],
                            ),
                            Text("${productModel.streetWidth} م "),
                          ],
                        )),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF4F5F8),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.asset(
                                'assets/icons/building.png',
                                scale: 4,
                                color: Color(0xFFF99743),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                              ),
                              Text('${AppLocalizations.of(context).translate('floorNumber')}')
                            ],
                          ),
                          Text("${productModel.floor}")
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image.asset(
                                  'assets/icons/ad.png',
                                  scale: 4,
                                  color: Color(0xFFF99743),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                ),
                                Text('${AppLocalizations.of(context).translate(
                                    'adNumber')}')
                              ],
                            ),
                            Text("${productModel.id}"),
                          ],
                        )),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF4F5F8),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.asset(
                                'assets/icons/eye.png',
                                scale: 4,
                                color: Color(0xFFF99743),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                              ),
                              Text('${AppLocalizations.of(context).translate('views')}')
                            ],
                          ),
                          Text("${productModel.views}")
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 15)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${AppLocalizations.of(context).translate(
                            'DescriptionOfTheProperty')}",
                        style: TextStyle(color: Color(0xFF0D986A)),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 8)),
                    Text("${productModel.description}"),
                    Padding(padding: EdgeInsets.only(top: 15)),
                    Material(
                      elevation: 1,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Image.asset(
                                  'assets/icons/profile.png',
                                  scale: 3,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Text("${productModel.productCreator
                                          .name}"),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 5)),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                            border: Border.all(color: Color(0xFFE0E0E0)),
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                          child: Row(
                                            children: <Widget>[
                                              Image.asset(
                                                'assets/icons/phoneHolder.png',
                                                scale: 6,
                                                color: Color(0xFF0D986A),
                                              ),
                                              Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                              Text("${AppLocalizations.of(context).translate('call')}"),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                            border: Border.all(color: Color(0xFFE0E0E0)),
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                          child: Row(
                                            children: <Widget>[
                                              Image.asset(
                                                'assets/icons/chat.png',
                                                scale: 6,
                                                color: Color(0xFF0D986A),
                                              ),
                                              Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                                              Text("${AppLocalizations.of(
                                                  context).translate('chat')}"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            Image.asset(
                              'assets/icons/pin.png',
                              scale: 4.5,
                              color: Color(productModel.categoryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 25)),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      height: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _kGooglePlex,
                        markers: _markers,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 25)),
//                    Align(
//                      alignment: Alignment.centerRight,
//                      child: Text(
//                        "${AppLocalizations.of(context).translate('similarAds')}",
//                        style: TextStyle(color: Color(0xFF0D986A)),
//                      ),
//                    ),
//                    Padding(padding: EdgeInsets.only(top: 15)),
//                    ListView.builder(
//                      primary: false,
//                      shrinkWrap: true,
//                      physics: NeverScrollableScrollPhysics(),
//                      itemCount: 5,
//                      itemBuilder: (context, index) {
//                        return HomeCard();
//                      },
//                    ),
                    Padding(padding: EdgeInsets.only(top: MediaQuery
                        .of(context)
                        .padding
                        .top)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
