class UserSession {
  final String userId;
  final String userName;
  final String userShortname;
  final String? avatarUrl;
  final String userType;
  final String email;
  final String broker;
  final UserMeta meta;
  final List<String> products;
  final List<String> orderTypes;
  final List<String> exchanges;
  final String accessToken;
  final String refreshToken;
  final String apiKey;
  final String publicToken;
  final DateTime loginTime;

  UserSession({
    required this.userId,
    required this.userName,
    required this.userShortname,
    this.avatarUrl,
    required this.userType,
    required this.email,
    required this.broker,
    required this.meta,
    required this.products,
    required this.orderTypes,
    required this.exchanges,
    required this.accessToken,
    required this.refreshToken,
    required this.apiKey,
    required this.publicToken,
    required this.loginTime,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) => UserSession(
        userId: json['user_id'],
        userName: json['user_name'],
        userShortname: json['user_shortname'],
        avatarUrl: json['avatar_url'],
        userType: json['user_type'],
        email: json['email'],
        broker: json['broker'],
        meta: UserMeta.fromJson(json['meta']),
        products: List<String>.from(json['products']),
        orderTypes: List<String>.from(json['order_types']),
        exchanges: List<String>.from(json['exchanges']),
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
        apiKey: json['api_key'],
        publicToken: json['public_token'],
        loginTime: DateTime.parse(json['login_time']),
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'user_name': userName,
        'user_shortname': userShortname,
        'avatar_url': avatarUrl,
        'user_type': userType,
        'email': email,
        'broker': broker,
        'meta': meta.toJson(),
        'products': products,
        'order_types': orderTypes,
        'exchanges': exchanges,
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'api_key': apiKey,
        'public_token': publicToken,
        'login_time': loginTime.toIso8601String(),
      };
}

class UserSessionTokens {
  final String userId;
  final String accessToken;
  final String refreshToken;

  UserSessionTokens({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserSessionTokens.fromJson(Map<String, dynamic> json) =>
      UserSessionTokens(
        userId: json['user_id'],
        accessToken: json['access_token'],
        refreshToken: json['refresh_token'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'access_token': accessToken,
        'refresh_token': refreshToken,
      };
}

class Bank {
  final String name;
  final String branch;
  final String account;

  Bank({
    required this.name,
    required this.branch,
    required this.account,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        name: json['name'],
        branch: json['branch'],
        account: json['account'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'branch': branch,
        'account': account,
      };
}

class UserMeta {
  final String dematConsent;

  UserMeta({required this.dematConsent});

  factory UserMeta.fromJson(Map<String, dynamic> json) =>
      UserMeta(dematConsent: json['demat_consent']);

  Map<String, dynamic> toJson() => {'demat_consent': dematConsent};
}

class FullUserMeta {
  final String dematConsent;
  final String silo;
  final List<String> accountBlocks;

  FullUserMeta({
    required this.dematConsent,
    required this.silo,
    required this.accountBlocks,
  });

  factory FullUserMeta.fromJson(Map<String, dynamic> json) => FullUserMeta(
        dematConsent: json['poa'],
        silo: json['silo'],
        accountBlocks: List<String>.from(json['account_blocks']),
      );

  Map<String, dynamic> toJson() => {
        'poa': dematConsent,
        'silo': silo,
        'account_blocks': accountBlocks,
      };
}

class UserProfile {
  final String userId;
  final String userName;
  final String userShortname;
  final String? avatarUrl;
  final String userType;
  final String email;
  final String broker;
  final UserMeta meta;
  final List<String> products;
  final List<String> orderTypes;
  final List<String> exchanges;

  UserProfile({
    required this.userId,
    required this.userName,
    required this.userShortname,
    this.avatarUrl,
    required this.userType,
    required this.email,
    required this.broker,
    required this.meta,
    required this.products,
    required this.orderTypes,
    required this.exchanges,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userId: json['user_id'],
        userName: json['user_name'],
        userShortname: json['user_shortname'],
        avatarUrl: json['avatar_url'],
        userType: json['user_type'],
        email: json['email'],
        broker: json['broker'],
        meta: UserMeta.fromJson(json['meta']),
        products: List<String>.from(json['products']),
        orderTypes: List<String>.from(json['order_types']),
        exchanges: List<String>.from(json['exchanges']),
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'user_name': userName,
        'user_shortname': userShortname,
        'avatar_url': avatarUrl,
        'user_type': userType,
        'email': email,
        'broker': broker,
        'meta': meta.toJson(),
        'products': products,
        'order_types': orderTypes,
        'exchanges': exchanges,
      };
}

class FullUserProfile {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final String userType;
  final String email;
  final String phone;
  final String broker;
  final String twofaType;
  final List<Bank> banks;
  final List<String> dpIds;
  final List<String> products;
  final List<String> orderTypes;
  final List<String> exchanges;
  final String pan;
  final String userShortname;
  final List<String> tags;
  final String passwordTimestamp;
  final String twofaTimestamp;
  final FullUserMeta meta;

  FullUserProfile({
    required this.userId,
    required this.userName,
    this.avatarUrl,
    required this.userType,
    required this.email,
    required this.phone,
    required this.broker,
    required this.twofaType,
    required this.banks,
    required this.dpIds,
    required this.products,
    required this.orderTypes,
    required this.exchanges,
    required this.pan,
    required this.userShortname,
    required this.tags,
    required this.passwordTimestamp,
    required this.twofaTimestamp,
    required this.meta,
  });

  factory FullUserProfile.fromJson(Map<String, dynamic> json) =>
      FullUserProfile(
        userId: json['user_id'],
        userName: json['user_name'],
        avatarUrl: json['avatar_url'],
        userType: json['user_type'],
        email: json['email'],
        phone: json['phone'],
        broker: json['broker'],
        twofaType: json['twofa_type'],
        banks: (json['bank_accounts'] as List)
            .map((e) => Bank.fromJson(e))
            .toList(),
        dpIds: List<String>.from(json['dp_ids']),
        products: List<String>.from(json['products']),
        orderTypes: List<String>.from(json['order_types']),
        exchanges: List<String>.from(json['exchanges']),
        pan: json['pan'],
        userShortname: json['user_shortname'],
        tags: List<String>.from(json['tags']),
        passwordTimestamp: json['password_timestamp'],
        twofaTimestamp: json['twofa_timestamp'],
        meta: FullUserMeta.fromJson(json['meta']),
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'user_name': userName,
        'avatar_url': avatarUrl,
        'user_type': userType,
        'email': email,
        'phone': phone,
        'broker': broker,
        'twofa_type': twofaType,
        'bank_accounts': banks.map((e) => e.toJson()).toList(),
        'dp_ids': dpIds,
        'products': products,
        'order_types': orderTypes,
        'exchanges': exchanges,
        'pan': pan,
        'user_shortname': userShortname,
        'tags': tags,
        'password_timestamp': passwordTimestamp,
        'twofa_timestamp': twofaTimestamp,
        'meta': meta.toJson(),
      };
}

class Margins {
  final String category;
  final bool enabled;
  final double net;
  final AvailableMargins available;
  final UsedMargins used;

  Margins({
    required this.category,
    required this.enabled,
    required this.net,
    required this.available,
    required this.used,
  });

  factory Margins.fromJson(Map<String, dynamic> json) => Margins(
        category: json['category'] ?? '',
        enabled: json['enabled'],
        net: (json['net'] as num).toDouble(),
        available: AvailableMargins.fromJson(json['available']),
        used: UsedMargins.fromJson(json['utilised']),
      );

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'net': net,
        'available': available.toJson(),
        'utilised': used.toJson(),
      };
}

class AvailableMargins {
  final double adhocMargin;
  final double cash;
  final double collateral;
  final double intradayPayin;
  final double liveBalance;
  final double openingBalance;

  AvailableMargins({
    required this.adhocMargin,
    required this.cash,
    required this.collateral,
    required this.intradayPayin,
    required this.liveBalance,
    required this.openingBalance,
  });

  factory AvailableMargins.fromJson(Map<String, dynamic> json) =>
      AvailableMargins(
        adhocMargin: (json['adhoc_margin'] as num).toDouble(),
        cash: (json['cash'] as num).toDouble(),
        collateral: (json['collateral'] as num).toDouble(),
        intradayPayin: (json['intraday_payin'] as num).toDouble(),
        liveBalance: (json['live_balance'] as num).toDouble(),
        openingBalance: (json['opening_balance'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'adhoc_margin': adhocMargin,
        'cash': cash,
        'collateral': collateral,
        'intraday_payin': intradayPayin,
        'live_balance': liveBalance,
        'opening_balance': openingBalance,
      };
}

class UsedMargins {
  final double debits;
  final double exposure;
  final double m2mRealised;
  final double m2mUnrealised;
  final double optionPremium;
  final double payout;
  final double span;
  final double holdingSales;
  final double turnover;
  final double liquidCollateral;
  final double stockCollateral;
  final double delivery;

  UsedMargins({
    required this.debits,
    required this.exposure,
    required this.m2mRealised,
    required this.m2mUnrealised,
    required this.optionPremium,
    required this.payout,
    required this.span,
    required this.holdingSales,
    required this.turnover,
    required this.liquidCollateral,
    required this.stockCollateral,
    required this.delivery,
  });

  factory UsedMargins.fromJson(Map<String, dynamic> json) => UsedMargins(
        debits: (json['debits'] as num).toDouble(),
        exposure: (json['exposure'] as num).toDouble(),
        m2mRealised: (json['m2m_realised'] as num).toDouble(),
        m2mUnrealised: (json['m2m_unrealised'] as num).toDouble(),
        optionPremium: (json['option_premium'] as num).toDouble(),
        payout: (json['payout'] as num).toDouble(),
        span: (json['span'] as num).toDouble(),
        holdingSales: (json['holding_sales'] as num).toDouble(),
        turnover: (json['turnover'] as num).toDouble(),
        liquidCollateral: (json['liquid_collateral'] as num).toDouble(),
        stockCollateral: (json['stock_collateral'] as num).toDouble(),
        delivery: (json['delivery'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'debits': debits,
        'exposure': exposure,
        'm2m_realised': m2mRealised,
        'm2m_unrealised': m2mUnrealised,
        'option_premium': optionPremium,
        'payout': payout,
        'span': span,
        'holding_sales': holdingSales,
        'turnover': turnover,
        'liquid_collateral': liquidCollateral,
        'stock_collateral': stockCollateral,
        'delivery': delivery,
      };
}

class AllMargins {
  final Margins equity;
  final Margins commodity;

  AllMargins({
    required this.equity,
    required this.commodity,
  });

  factory AllMargins.fromJson(Map<String, dynamic> json) => AllMargins(
        equity: Margins.fromJson(json['equity']),
        commodity: Margins.fromJson(json['commodity']),
      );

  Map<String, dynamic> toJson() => {
        'equity': equity.toJson(),
        'commodity': commodity.toJson(),
      };
}
