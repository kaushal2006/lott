import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Created by Marcin Szałek

///NumberPicker is a widget designed to pick a number between #minValue and #maxValue
class NumberPicker extends StatelessWidget {
  ///height of every list element
  static const double DEFAULT_ITEM_EXTENT = 50.0;

  //added by kaushal
  final int numOfItemsAround; //1,3,5,7,9 etc

  ///width of list view
  static const double DEFAULT_LISTVIEW_HEIGHT = 100;

  ///constructor for integer number picker
  NumberPicker.integer({
    Key key,
    @required int initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.scaleSize,
    @required this.onChanged,
    @required this.numOfItemsAround,
    this.itemExtent = DEFAULT_ITEM_EXTENT,
    this.listViewHeight = DEFAULT_LISTVIEW_HEIGHT,
    this.step = 1,
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(maxValue > minValue),
        //assert(scaleSize != null),
        //assert(scaleSize < maxValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedIntValue = initialValue,
        intScrollController = new ScrollController(
          initialScrollOffset: (initialValue - minValue) ~/ step * itemExtent,
        ),
        _listViewWidth = ((numOfItemsAround * 2) + 1) * itemExtent,
        /*****kaushal 3 for 3 items, 5 for 5, 7 for 7*/

        integerItemCount = (maxValue - minValue) ~/ step + 1,
        super(key: key);

  ///called when selected value changes
  final ValueChanged<num> onChanged;

  ///min value user can pick
  final int minValue;

  ///max value user can pick
  final int maxValue;

  final int scaleSize;

  ///inidcates how many decimal places to show
  /// e.g. 0=>[1,2,3...], 1=>[1.0, 1.1, 1.2...]  2=>[1.00, 1.01, 1.02...]
  //final int decimalPlaces1;

  ///height of every list element in pixels
  final double itemExtent;

  ///view will always contain only 3 elements of list in pixels
  final double listViewHeight;

  ///width of list view in pixels
  final double _listViewWidth;

  ///ScrollController used for integer list
  final ScrollController intScrollController;

  ///Currently selected integer value
  final int selectedIntValue;

  ///Step between elements. Only for integer datePicker
  ///Examples:
  /// if step is 100 the following elements may be 100, 200, 300...
  /// if min=0, max=6, step=3, then items will be 0, 3 and 6
  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final int step;

  ///Amount of items
  final int integerItemCount;

  final Widget scaleTopBottomDefault = Container(
    height: 10,
    width: 2,
    color: Colors.white,
  );

  final Widget scaleTopSelected = RotatedBox(
    child: Container(
      padding: const EdgeInsets.all(0.0),
      child: Icon(Icons.label, size: 28, color: Colors.white),
      height: 28,
    ),
    quarterTurns: 1,
  );
/*
  final Widget scaleBottomSelected = RotatedBox(
    child: Container(
      alignment: Alignment.bottomCenter,
      child: Icon(Icons.label, size: 20, color: Colors.white),
      height: 20,
    ),
    quarterTurns: 3,
  );
*/
  final BoxDecoration scaleGreen = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.1, 0.3, 0.7, 0.9],
      colors: [
        Color.fromRGBO(51, 175, 157, 1.0),
        Color.fromRGBO(37, 188, 166, 1.0),
        Color.fromRGBO(37, 188, 166, 1.0),
        Color.fromRGBO(51, 175, 157, 1.0),
      ],
    ),
  );

  final BoxDecoration scaleBlue = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.1, 0.3, 0.7, 0.9],
      colors: [
        Color.fromRGBO(27, 109, 132, 1.0),
        Color.fromRGBO(16, 120, 149, 1.0),
        Color.fromRGBO(16, 120, 149, 1.0),
        Color.fromRGBO(27, 109, 132, 1.0),
      ],
    ),
  );
  //
  //----------------------------- PUBLIC ------------------------------
  //

  animateInt(int valueToSelect) {
    int diff = valueToSelect - minValue;
    int index = diff ~/ step;
    animateIntToIndex(index);
  }

  animateIntToIndex(int index) {
    _animate(intScrollController, index * itemExtent);
  }

  //
  //----------------------------- VIEWS -----------------------------
  //

  ///main widget
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        _integerListView(themeData),
        scaleTopSelected,
      ],
    );
  }

  Widget _integerListView(ThemeData themeData) {
    var listItemCount = integerItemCount +
        (((numOfItemsAround ~/ 2).floor() * 2) +
            2); //kaushal 1=2, 2=4,3=4 ** added later

    return new NotificationListener(
      child: new Container(
        height: listViewHeight,
        width: _listViewWidth,
        child: new ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: intScrollController,
          itemExtent: itemExtent,
          itemCount: listItemCount,
          cacheExtent: _calculateCacheExtent(listItemCount),
          itemBuilder: (BuildContext context, int index) {
            final int value = _intValueFromIndex(index);

            //define special style for selected (middle) element
            final TextStyle itemStyle =
                /*(value == selectedIntValue)
                ? TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    //fontWeight: FontWeight.bold
                  )
                : */
                TextStyle(
              color: Colors.white,
              fontSize: 15,
              //fontWeight: FontWeight.bold
            );

/*
            int rightExtraIndexVal = listItemCount -
                ((((numOfItemsAround * 2) + 1) % 2) + 2) -
                1; /*****kaushal 1 for 3 items, 3 for 5, 5 for 7*/
                
*/
            bool isExtra = index <
                    numOfItemsAround || /*****kaushal 1 for 3 items, 2 for 5, 3 for 7*/
                index >= integerItemCount;

            //print(index.toString() + "`" + integerItemCount.toString());
            int displayVal =
                ((value % scaleSize == 0) ? scaleSize : (value % scaleSize));

            BoxDecoration scaleDecoration =
                (value / scaleSize).ceil().isEven ? scaleGreen : scaleBlue;
            //print(value);
            return Container(
              child: isExtra
                  ? Container(
                      //decoration: scaleBlue,
                      color: Colors.grey,
                    )
                  : Container(
                      decoration: scaleDecoration,
                      child: new Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          scaleTopBottomDefault,
                          new Text(displayVal.toString(), style: itemStyle),
                          scaleTopBottomDefault,
                        ],
                      ))),
            );
          },
        ),
      ),
      onNotification: _onIntegerNotification,
    );
  }

  //
  // ----------------------------- LOGIC -----------------------------
  //

  int _intValueFromIndex(int index) {
    index = index -
        numOfItemsAround; /*****kaushal 1 for 3 items, 2 for 5, 3 for 7*/
    index %= integerItemCount;
    return minValue + index * step;
  }

  bool _onIntegerNotification(Notification notification) {
    /*
    
    if (intScrollController.initialScrollOffset == 0.0
    && intScrollController.offset > 50) {
      //index = numOfItemsAround
      print(intScrollController.initialScrollOffset);
      print(intScrollController.offset);

      try {
        //print(intScrollController.offset);
        //intScrollController.jumpTo(0.0);
      } catch (e) {}
      //intScrollController.
    }
*/
    if (notification is ScrollNotification) {
      //calculate
      int intIndexOfMiddleElement =
          ((notification.metrics.pixels) / itemExtent).round();

      intIndexOfMiddleElement = intIndexOfMiddleElement.clamp(
          0,
          integerItemCount -
              numOfItemsAround); /*****kaushal 1 for 3 items, 2 for 5, 3 for 7*/

      int intValueInTheMiddle = _intValueFromIndex(intIndexOfMiddleElement +
          numOfItemsAround); /*****kaushal 1 for 3 items, 2 for 5, 3 for 7*/

      intValueInTheMiddle = _normalizeIntegerMiddleValue(intValueInTheMiddle);

//print(intIndexOfMiddleElement.toString() + "=" + intValueInTheMiddle.toString());

      if (_userStoppedScrolling(notification, intScrollController)) {
        //center selected value
        animateIntToIndex(intIndexOfMiddleElement);
      }

      //update selection
      if (intValueInTheMiddle != selectedIntValue) {
        num newValue;
        newValue = (intValueInTheMiddle);
        onChanged(newValue);
      }
    }
    return true;
  }

  ///There was a bug, when if there was small integer range, e.g. from 1 to 5,
  ///When user scrolled to the top, whole listview got displayed.
  ///To prevent this we are calculating cacheExtent by our own so it gets smaller if number of items is smaller
  double _calculateCacheExtent(int itemCount) {
    double cacheExtent = 250.0; //default cache extent
    if ((itemCount - 2) * DEFAULT_ITEM_EXTENT <= cacheExtent) {
      cacheExtent = ((itemCount - 3) * DEFAULT_ITEM_EXTENT);
    }
    return cacheExtent;
  }

/*
  ScrollController _resetController(intScrollController) {
    if (intScrollController.initialScrollOffset == 0.0) {
      //index = numOfItemsAround
      //print(intScrollController.initialScrollOffset);
      try {
        //print(intScrollController.offset);
        intScrollController.jumpTo(intScrollController.initialScrollOffset);
      } catch (e) {}
      //intScrollController.
    }
    return intScrollController;
  }
*/

  ///When overscroll occurs on iOS,
  ///we can end up with value not in the range between [minValue] and [maxValue]
  ///To avoid going out of range, we change values out of range to border values.
  int _normalizeMiddleValue(int valueInTheMiddle, int min, int max) {
    //print(valueInTheMiddle.toString() + "&"+ max.toString());
    return math.max(math.min(valueInTheMiddle, max), min);
  }

  int _normalizeIntegerMiddleValue(int integerValueInTheMiddle) {
    //print(integerValueInTheMiddle.toString());

    //make sure that max is a multiple of step
    int max = (maxValue ~/ step) * step;
    return _normalizeMiddleValue(integerValueInTheMiddle, minValue, max);
  }

  ///indicates if user has stopped scrolling so we can center value in the middle
  bool _userStoppedScrolling(
      Notification notification, ScrollController scrollController) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  ///scroll to selected value
  _animate(ScrollController scrollController, double value) {
    scrollController.animateTo(value,
        duration: new Duration(seconds: 1), curve: new ElasticOutCurve());
  }
}
