import 'package:flutter/material.dart';
import 'package:wiread/models/user.dart';
import 'package:wiread/util/config.dart';

class UserCard extends StatefulWidget {
  final User user;

  UserCard(this.user);

  @override
  UserCardState createState() {
    return new UserCardState(user);
  }
}

class UserCardState extends State<UserCard> {
  final User user;
  String renderUrl;

  UserCardState(this.user);

  void initState() {
    super.initState();
    renderDogPic();
  }

  void renderDogPic() async {
    await user.getAvatarUrl();
    setState(() {
      renderUrl = user.avatarUrl;
    });
  }

  Widget get dogImage {
    var userAvatar = new Hero(
      tag: user,
      child: new Container(
        width: 100.0,
        height: 100.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: new NetworkImage(renderUrl ?? ''),
          ),
        ),
      ),
    );

    var placeholder = new Container(
        width: 100.0,
        height: 100.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          gradient: new LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black54, Colors.black, Colors.blueGrey[600]],
          ),
        ),
        alignment: Alignment.center,
        child: new Text(
          user.username,
          textAlign: TextAlign.center,
        ));

    var crossFade = new AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: userAvatar,
      crossFadeState: renderUrl == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: new Duration(milliseconds: 1000),
    );

    return crossFade;
  }

  Widget get userCard {
    return new Positioned(
      right: 0.0,
      child: new Container(
        width: 290.0,
        height: 115.0,
        child: new Card(
          color: Colors.black87,
          child: new Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 64.0,
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text(user.username,
                    style: Theme.of(context).textTheme.headline),
                new Text(user.username,
                    style: Theme.of(context).textTheme.subhead),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () => showDogDetailPage(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: new Container(
          height: 115.0,
          child: new Stack(
            children: <Widget>[
              userCard,
              new Positioned(top: 7.5, child: dogImage),
            ],
          ),
        ),
      ),
    );
  }

  showDogDetailPage() {
    Config.getInstance().router.navigateTo(context, "/devices?userId=${user.id}");
  }
}
