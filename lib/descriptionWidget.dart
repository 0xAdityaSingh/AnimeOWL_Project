import 'package:animetv/Model/info.dart';
import 'package:animetv/devideor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionWidget extends StatefulWidget {
  final Information twistModel;

  DescriptionWidget({
    Key key,
    this.twistModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DescriptionWidgetState();
  }
}

class _DescriptionWidgetState extends State<DescriptionWidget>
    with TickerProviderStateMixin {
  Animation<double> height;
  bool isNotExpanded = true;
  AnimationController _controller;
  Animation<double> _sizeAnimation;
  GlobalKey _keyFoldChild;
  RenderBox _renderBox;

  void _afterLayout(_) async {
    if (widget.twistModel == null) return;
    _renderBox = _keyFoldChild.currentContext.findRenderObject();
    _sizeAnimation = Tween<double>(
      end: _renderBox.size.height,
      begin: _renderBox.size.height > 150 ? 150.0 : _renderBox.size.height,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
    setState(() {});
  }

  void toggleExpand() {
    setState(() {
      isNotExpanded = !isNotExpanded;
    });
    playAnim();
  }

  void playAnim() {
    if (isNotExpanded) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void initState() {
    _keyFoldChild = GlobalKey();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _afterLayout(_);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.twistModel == null) return Container();
    return Container(
      margin: EdgeInsets.only(
        bottom: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return DeviceOrientationBuilder(
                portrait: ClipRect(
                  child: SizedOverflowBox(
                    size: Size(double.infinity, _sizeAnimation?.value ?? 150.0),
                    alignment: Alignment.topCenter,
                    child: child,
                  ),
                ),
                landscape: child,
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              alignment: Alignment.centerLeft,
              key: _keyFoldChild,
              child: Text(
                widget.twistModel.synopsis,
                textAlign: TextAlign.left,
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).hintColor,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          Visibility(
            visible: ((_renderBox?.size?.height ?? 151) > 150) &&
                MediaQuery.of(context).orientation == Orientation.portrait,
            child: Container(
              margin: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 12.0,
                bottom: 0.0,
              ),
              child: GestureDetector(
                onTap: () {
                  toggleExpand();
                },
                child: Text(
                  isNotExpanded ? 'Show More' : 'Show Less',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
