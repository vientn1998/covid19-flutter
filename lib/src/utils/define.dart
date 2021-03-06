String pathAssets = 'assets/images/';
const double heightButtonSuvery = 46;
const double borderRadiusButtonOutline = 24;
const double heightSpaceSmall = 10;
const double heightSpaceNormal = 20;
const double heightSpaceLarge = 30;
const double sizeIconHome = 26;
const double sizeBoxIcon = 45;
const double paddingDefault = 16;
const double paddingNavi = 22;
const double paddingSmall = 8;
const double paddingLarge = 32;
const double heightNavigation = 56;
const double heightButton = 50;


enum SharePreferenceKey {
  isLogged,
  isApproveSuvery,
  isIntroduce,
  uuid,
  isBackChooseRole,
  user,
  location,
  phone,
}

enum StatusTabHome {
  today,
  total,
  yesterday,
}

enum StatusSchedule {
  New,
  Approved,
  Today,
  History,
  Done,
  Clear,
  Canceled
}

extension ParseToString on StatusSchedule {
  String toCastEnumIntoString() {
    return this.toString().split('.').last;
  }
}