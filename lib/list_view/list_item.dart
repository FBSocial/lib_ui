import 'package:flutter/material.dart';
import 'package:lib_ui/button/fade_background_button.dart';

class ListItem extends StatelessWidget {
  final Widget? icon;
  final String? title;
  final String? content;
  final VoidCallback? onTap;

  const ListItem({
    this.icon,
    this.content,
    this.title,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeBackgroundButton(
      tapDownBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 16, right: 8),
            height: 40,
            width: 40,
            child: icon ?? Container(),
          ),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 6),
                  if (title != null)
                    Text(
                      title!,
                      style: Theme.of(context).textTheme.subtitle2,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )
                  else
                    Container(),
                  if (content != null)
                    Text(
                      content!,
                      style: Theme.of(context).textTheme.caption,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )
                  else
                    Container(),
                ]),
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
    );
  }
}
