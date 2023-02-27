import 'package:appventure/components/black_divider.dart';
import 'package:appventure/services/database/database_service.dart';
import 'package:appventure/theme/custom_theme.dart';
import 'package:appventure/utils/widget_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef SearchCallback = Function(String args);

class SearchHistoryView extends StatefulWidget {
  final List<String> localSearchHistory;
  final VoidCallback refreshLocalHistory;
  final SearchCallback searchCallback;

  SearchHistoryView(this.localSearchHistory, this.refreshLocalHistory, this.searchCallback, {Key key}) : super(key: key);

  @override
  _SearchHistoryViewState createState() {
    return _SearchHistoryViewState();
  }
}

class _SearchHistoryViewState extends State<SearchHistoryView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Letzte Suchanfragen',
                style: TextStyle(
                  fontSize: Dimensions.getScaledSize(20.0),
                  fontWeight: FontWeight.bold,
                  color: CustomTheme.primaryColorDark,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await HiveService.clearLocalSearchHistory();
                  widget.refreshLocalHistory.call();
                },
                child: Text(
                  'Alles löschen',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(13.0),
                    fontWeight: FontWeight.bold,
                    color: CustomTheme.primaryColorDark,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: Dimensions.getScaledSize(10.0),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return HistoryView(
                data: widget.localSearchHistory[index],
                callback: () {
                  widget.searchCallback.call(widget.localSearchHistory[index]);
                },
              );
            },
            itemCount: widget.localSearchHistory.length,
          )
        ],
      ),
    );
  }
}

class HistoryView extends StatelessWidget {
  final VoidCallback callback;
  final bool isHistoryView;
  final String data;

  HistoryView({this.isHistoryView = true, this.data, @required this.callback}) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: Dimensions.getScaledSize(8.0)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: Dimensions.getScaledSize(32.0),
                  width: Dimensions.getScaledSize(32.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.getScaledSize(8.0)),
                    color: CustomTheme.primaryColorLight.withOpacity(0.2),
                  ),
                  child: isHistoryView
                      ? Icon(
                          Icons.history,
                          size: Dimensions.getScaledSize(20.0),
                          color: CustomTheme.primaryColor,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            'lib/assets/images/outline_travel_explore.png',
                            color: CustomTheme.primaryColor,
                          ),
                        ),
                ),
                SizedBox(
                  width: 12.0,
                ),
                Expanded(
                    child: Text(
                  data,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: Dimensions.getScaledSize(16.0),
                    color: CustomTheme.primaryColorDark,
                  ),
                )),
                Visibility(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: Dimensions.getScaledSize(16.0),
                    color: CustomTheme.primaryColorDark,
                  ),
                  visible: isHistoryView,
                ),
              ],
            ),
          ),
          Visibility(
            child: BlackDivider(
              height: 0.5,
            ),
            visible: isHistoryView,
          )
        ],
      ),
      onTap: callback,
    );
  }
}
