// event_info_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class EventInfoPage extends StatefulWidget {
  // Constants for styling
  static const double _borderRadius = 28.0;
  static const double _padding = 24.0;
  static const double _iconSize = 24.0;
  static const double _spacing = 16.0;

  // Colors
  static const Color _primaryColor = Color(0xFF4CAF50); // Green
  static const Color _backgroundColor = Colors.black;
  static const Color _cardColor = Color(0xFFE8F5E9);
  static const Color _textColor = Color(0xFF212121);
  static const Color _secondaryTextColor = Color(0xFF757575);

  @override
  State<EventInfoPage> createState() => _EventInfoPageState();
}

class _EventInfoPageState extends State<EventInfoPage> {
  double _dragPosition = 0;

  void _animateAndNavigate() async {
    // Add haptic feedback
    await HapticFeedback.heavyImpact();

    await Future.delayed(Duration(milliseconds: 200));
    Navigator.of(context).pushNamed('/showtickets');

    // /showtickets

    // Reset position after navigation
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _dragPosition = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EventInfoPage._backgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 80,
      title: Text(
        'Clean Marine Drive',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                'https://images.ctfassets.net/23aumh6u8s0i/4TsG2mTRrLFhlQ9G1m19sC/4c9f98d56165a0bdd71cbe7b9c2e2484/flutter',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeaderImage(context),
          _buildEventDetailsCard(context),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.28,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://media.istockphoto.com/id/603164912/photo/suburb-asphalt-road-and-sun-flowers.jpg?s=612x612&w=0&k=20&c=qLoQ5QONJduHrQ0kJF3fvoofmGAFcrq6cL84HbzdLQM=',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildEventDetailsCard(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -80),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: EventInfoPage._padding),
        decoration: BoxDecoration(
          color: EventInfoPage._cardColor,
          borderRadius: BorderRadius.circular(EventInfoPage._borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(EventInfoPage._padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEventHeader(),
              SizedBox(height: EventInfoPage._spacing * 1.5),
              _buildEventInfo(),
              SizedBox(height: EventInfoPage._spacing * 1.5),
              _buildDescription(),
              SizedBox(height: EventInfoPage._spacing * 1.5),
              _buildTicketButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Clean Marine Drive',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: EventInfoPage._textColor,
            ),
          ),
        ),
        Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: EventInfoPage._primaryColor,
            boxShadow: [
              BoxShadow(
                color: EventInfoPage._primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'EVENT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventInfo() {
    return Column(
      children: [
        _buildInfoRow(Icons.location_on, "Mumbai, Marine drive"),
        SizedBox(height: EventInfoPage._spacing),
        _buildInfoRow(Icons.calendar_today, '1 April, 2024'),
        SizedBox(height: EventInfoPage._spacing),
        _buildInfoRow(Icons.access_time, '09:16 AM'),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon,
            size: EventInfoPage._iconSize, color: EventInfoPage._primaryColor),
        SizedBox(width: EventInfoPage._spacing),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: EventInfoPage._secondaryTextColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: EdgeInsets.all(EventInfoPage._spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(EventInfoPage._borderRadius / 2),
      ),
      child: Text(
        'Join us for a community initiative to clean Marine Drive and make our city better. Together, we can make a difference!',
        style: TextStyle(
          fontSize: 16,
          color: EventInfoPage._secondaryTextColor,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildTicketButton() {
    final double buttonWidth =
        MediaQuery.of(context).size.width - (EventInfoPage._padding * 2);
    final double buttonHeight = 56.0;

    return StatefulBuilder(builder: (context, setState) {
      return Container(
        width: buttonWidth,
        height: buttonHeight,
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              double newPosition = _dragPosition + details.delta.dx;
              _dragPosition = newPosition.clamp(0, buttonWidth - 48);

              // Add light haptic feedback during drag
              if (_dragPosition % 20 == 0) {
                HapticFeedback.lightImpact();
              }
            });
          },
          onHorizontalDragEnd: (details) {
            if (_dragPosition > buttonWidth * 0.6) {
              setState(() {
                _dragPosition = buttonWidth - 48;
                _animateAndNavigate();
              });
            } else {
              setState(() {
                _dragPosition = 0;
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: EventInfoPage._textColor,
              borderRadius: BorderRadius.circular(EventInfoPage._borderRadius),
            ),
            child: Stack(
              children: [
                // Progress indicator
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  width: _dragPosition + 48,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius:
                        BorderRadius.circular(EventInfoPage._borderRadius),
                  ),
                ),
                // Text
                Center(
                  child: Text(
                    'Swipe to show ticket',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Draggable arrow
                AnimatedPositioned(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeOutCubic,
                  left: _dragPosition,
                  top: 4,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
