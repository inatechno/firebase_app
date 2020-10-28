class ModelHistory {
  String result;
  String msg;
  List<DataHistory> data;

  ModelHistory({this.result, this.msg, this.data});

  ModelHistory.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<DataHistory>();
      json['data'].forEach((v) {
        data.add(new DataHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataHistory {
  String idBooking;
  String bookingTanggal;
  String bookingFrom;
  String bookingFromLat;
  String bookingFromLng;
  String bookingTujuan;
  String bookingTujuanLat;
  String bookingTujuanLng;
  String bookingCatatan;
  String bookingBiayaUser;
  String bookingBiayaDriver;
  String bookingJarak;
  String bookingUser;
  String bookingDriver;
  String bookingTakeTanggal;
  String bookingCompleteTanggal;
  String bookingStatus;
  String idUser;
  String userNama;
  String userEmail;
  String userPassword;
  String userHp;
  Null userAvatar;
  String userGcm;
  String userRegister;
  String userLevel;
  String userStatus;

  DataHistory(
      {this.idBooking,
      this.bookingTanggal,
      this.bookingFrom,
      this.bookingFromLat,
      this.bookingFromLng,
      this.bookingTujuan,
      this.bookingTujuanLat,
      this.bookingTujuanLng,
      this.bookingCatatan,
      this.bookingBiayaUser,
      this.bookingBiayaDriver,
      this.bookingJarak,
      this.bookingUser,
      this.bookingDriver,
      this.bookingTakeTanggal,
      this.bookingCompleteTanggal,
      this.bookingStatus,
      this.idUser,
      this.userNama,
      this.userEmail,
      this.userPassword,
      this.userHp,
      this.userAvatar,
      this.userGcm,
      this.userRegister,
      this.userLevel,
      this.userStatus});

  DataHistory.fromJson(Map<String, dynamic> json) {
    idBooking = json['id_booking'];
    bookingTanggal = json['booking_tanggal'];
    bookingFrom = json['booking_from'];
    bookingFromLat = json['booking_from_lat'];
    bookingFromLng = json['booking_from_lng'];
    bookingTujuan = json['booking_tujuan'];
    bookingTujuanLat = json['booking_tujuan_lat'];
    bookingTujuanLng = json['booking_tujuan_lng'];
    bookingCatatan = json['booking_catatan'];
    bookingBiayaUser = json['booking_biaya_user'];
    bookingBiayaDriver = json['booking_biaya_driver'];
    bookingJarak = json['booking_jarak'];
    bookingUser = json['booking_user'];
    bookingDriver = json['booking_driver'];
    bookingTakeTanggal = json['booking_take_tanggal'];
    bookingCompleteTanggal = json['booking_complete_tanggal'];
    bookingStatus = json['booking_status'];
    idUser = json['id_user'];
    userNama = json['user_nama'];
    userEmail = json['user_email'];
    userPassword = json['user_password'];
    userHp = json['user_hp'];
    userAvatar = json['user_avatar'];
    userGcm = json['user_gcm'];
    userRegister = json['user_register'];
    userLevel = json['user_level'];
    userStatus = json['user_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_booking'] = this.idBooking;
    data['booking_tanggal'] = this.bookingTanggal;
    data['booking_from'] = this.bookingFrom;
    data['booking_from_lat'] = this.bookingFromLat;
    data['booking_from_lng'] = this.bookingFromLng;
    data['booking_tujuan'] = this.bookingTujuan;
    data['booking_tujuan_lat'] = this.bookingTujuanLat;
    data['booking_tujuan_lng'] = this.bookingTujuanLng;
    data['booking_catatan'] = this.bookingCatatan;
    data['booking_biaya_user'] = this.bookingBiayaUser;
    data['booking_biaya_driver'] = this.bookingBiayaDriver;
    data['booking_jarak'] = this.bookingJarak;
    data['booking_user'] = this.bookingUser;
    data['booking_driver'] = this.bookingDriver;
    data['booking_take_tanggal'] = this.bookingTakeTanggal;
    data['booking_complete_tanggal'] = this.bookingCompleteTanggal;
    data['booking_status'] = this.bookingStatus;
    data['id_user'] = this.idUser;
    data['user_nama'] = this.userNama;
    data['user_email'] = this.userEmail;
    data['user_password'] = this.userPassword;
    data['user_hp'] = this.userHp;
    data['user_avatar'] = this.userAvatar;
    data['user_gcm'] = this.userGcm;
    data['user_register'] = this.userRegister;
    data['user_level'] = this.userLevel;
    data['user_status'] = this.userStatus;
    return data;
  }
}
