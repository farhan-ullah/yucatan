import 'package:yucatan/models/activity_model.dart';
import 'package:yucatan/models/file_model.dart';
import 'package:yucatan/services/response/user_login_response.dart';

activityModelFromJson(ActivityModel data, Map<String, dynamic> json) {
  if (json['location'] != null) {
    data.location = new ActivityModelLocation().fromJson(json['location']);
  }
  if (json['activityDetails'] != null) {
    data.activityDetails =
        new ActivityModelActivityDetails().fromJson(json['activityDetails']);
  }
  if (json['openingHours'] != null) {
    data.openingHours =
        ActivityModelOpeningHours.fromJson(json['openingHours']);
  }
  if (json['bookingDetails'] != null) {
    data.bookingDetails =
        new ActivityBookingDetails().fromJson(json['bookingDetails']);
  }
  if (json['tags'] != null) {
    data.tags = json['tags'].map((v) => v.toString()).toList().cast<String>();
  }
  if (json['categories'] != null) {
    data.categories = <ActivityCategory>[];
    (json['categories'] as List).forEach((v) {
      data.categories!.add(new ActivityCategory().fromJson(v));
    });
  }
  if (json['_id'] != null) {
    data.sId = json['_id'].toString();
  }
  if (json['title'] != null) {
    data.title = json['title'].toString();
  }
  if (json['description'] != null) {
    data.description = json['description'].toString();
  }
  if (json['bookings'] != null) {
    data.bookings = json['bookings'].toInt();
  }
  if (json['thumbnail'] != null) {
    data.thumbnail = FileModel.fromJson(json['thumbnail']);
  }
  if (json['createdAt'] != null) {
    data.createdAt = json['createdAt'].toString();
  }
  if (json['updatedAt'] != null) {
    data.updatedAt = json['updatedAt'].toString();
  }
  if (json['__v'] != null) {
    data.iV = json['__v'].toInt();
  }
  if (json['reviewCount'] != null) {
    data.reviewCount = json['reviewCount'].toInt();
  }
  if (json['reviewAverageRating'] != null) {
    data.reviewAverageRating =
        double.tryParse(json['reviewAverageRating'].toString())!;
  }
  if (json['priceFrom'] != null) {
    data.priceFrom = double.tryParse(json['priceFrom'].toString())!;
  }
  if (json['vendor'] != null) {
    data.vendor = new ActivityVendor().fromJson(json['vendor']);
  }
  if (json['privacy'] != null) {
    data.privacy = json['privacy'].toString();
  }
  return data;
}

Map<String, dynamic> activityModelToJson(ActivityModel entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.location != null) {
    data['location'] = entity.location!.toJson();
  }
  if (entity.activityDetails != null) {
    data['activityDetails'] = entity.activityDetails!.toJson();
  }
  if (entity.bookingDetails != null) {
    data['bookingDetails'] = entity.bookingDetails!.toJson();
  }
  data['tags'] = entity.tags;
  if (entity.categories != null) {
    data['categories'] = entity.categories!.map((v) => v.toJson()).toList();
  }
  data['_id'] = entity.sId;
  data['title'] = entity.title;
  data['description'] = entity.description;
  data['bookings'] = entity.bookings;
  data['thumbnail'] = entity.thumbnail;
  data['createdAt'] = entity.createdAt;
  data['updatedAt'] = entity.updatedAt;
  data['__v'] = entity.iV;
  data['reviewCount'] = entity.reviewCount;
  data['reviewAverageRating'] = entity.reviewAverageRating;
  data['vendor'] = entity.vendor!.toJson();
  data['privacy'] = entity.privacy;
  return data;
}

activityBookingDetailsFromJson(
    ActivityBookingDetails data, Map<String, dynamic> json) {
  if (json['currency'] != null) {
    data.currency = json['currency'].toString();
  }
  if (json['concurrentBookings'] != null) {
    data.concurrentBookings =
        new ActivityBookingConcurrent().fromJson(json['concurrentBookings']);
  }
  if (json['productCategories'] != null) {
    data.productCategories = <ProductCategory>[];
    (json['productCategories'] as List).forEach((v) {
      data.productCategories!.add(new ProductCategory.fromJson(v));
    });
  }
  return data;
}

Map<String, dynamic> activityBookingDetailsToJson(
    ActivityBookingDetails entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['currency'] = entity.currency;
  if (entity.concurrentBookings != null) {
    data['concurrentBookings'] = entity.concurrentBookings!.toJson();
  }

  //Adjust to new Product model
  // if (entity.ticketVariants != null) {
  //   data['ticketVariants'] = entity.ticketVariants.map((v) => v.toJson()).toList();
  // }
  return data;
}

activityBookingConcurrentFromJson(
    ActivityBookingConcurrent data, Map<String, dynamic> json) {
  if (json['concurrent'] != null) {
    data.concurrent = json['concurrent'].toInt();
  }
  if (json['hourly'] != null) {
    data.hourly = json['hourly'].toInt();
  }
  if (json['daily'] != null) {
    data.daily = json['daily'].toInt();
  }
  return data;
}

Map<String, dynamic> activityBookingConcurrentToJson(
    ActivityBookingConcurrent entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['concurrent'] = entity.concurrent;
  data['hourly'] = entity.hourly;
  data['daily'] = entity.daily;
  return data;
}

activityModelLocationFromJson(
    ActivityModelLocation data, Map<String, dynamic> json) {
  if (json['street'] != null) {
    data.street = json['street'].toString();
  }
  if (json['housenumber'] != null) {
    data.housenumber = json['housenumber'].toString();
  }
  if (json['zipcode'] != null) {
    data.zipcode = json['zipcode'].toInt();
  }
  if (json['city'] != null) {
    data.city = json['city'].toString();
  }
  if (json['state'] != null) {
    data.state = json['state'].toString();
  }
  if (json['country'] != null) {
    data.country = json['country'].toString();
  }
  if (json['lat'] != null) {
    data.lat = json['lat'].toString();
  }
  if (json['lon'] != null) {
    data.lon = json['lon'].toString();
  }
  return data;
}

Map<String, dynamic> activityModelLocationToJson(ActivityModelLocation entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['street'] = entity.street;
  data['housenumber'] = entity.housenumber;
  data['zipcode'] = entity.zipcode;
  data['city'] = entity.city;
  data['state'] = entity.state;
  data['country'] = entity.country;
  return data;
}

activityModelActivityDetailsFromJson(
    ActivityModelActivityDetails data, Map<String, dynamic> json) {
  if (json['media'] != null) {
    data.media =
        new ActivityModelActivityDetailsMedia().fromJson(json['media']);
  }
  if (json['title'] != null) {
    data.title = json['title'].toString();
  }
  if (json['shortDescription'] != null) {
    data.shortDescription = json['shortDescription'].toString();
  }
  if (json['longDescription'] != null) {
    data.longDescription = json['longDescription'].toString();
  }
  if (json['packageIncluded'] != null) {
    data.packageIncluded = json['packageIncluded'].toString();
  }
  if (json['packageNotIncluded'] != null) {
    data.packageNotIncluded = json['packageNotIncluded'].toString();
  }
  if (json['cancellation'] != null) {
    data.cancellation = json['cancellation'].toInt();
  }
  if (json['customFields'] != null) {
    data.customFields =
        new ActivityDetailsCustomFields().fromJson(json['customFields']);
  }
  if (json['reviews'] != null) {
    data.reviews = <ActivityModelActivityDetailsReview>[];
    (json['reviews'] as List).forEach((v) {
      data.reviews!.add(new ActivityModelActivityDetailsReview().fromJson(v));
    });
  }
  if (json['descriptionItems'] != null) {
    data.descriptionItems = <ActivityDetailDescriptionItemModel>[];
    (json['descriptionItems'] as List).forEach((v) {
      data.descriptionItems!
          .add(new ActivityDetailDescriptionItemModel().fromJson(v));
    });
  }
  return data;
}

Map<String, dynamic> activityModelActivityDetailsToJson(
    ActivityModelActivityDetails entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.media != null) {
    data['media'] = entity.media!.toJson();
  }
  data['title'] = entity.title;
  data['shortDescription'] = entity.shortDescription;
  data['longDescription'] = entity.longDescription;
  data['packageIncluded'] = entity.packageIncluded;
  data['packageNotIncluded'] = entity.packageNotIncluded;
  data['cancellation'] = entity.cancellation;
  if (entity.customFields != null) {
    data['customFields'] = entity.customFields!.toJson();
  }
  if (entity.reviews != null) {
    data['reviews'] = entity.reviews!.map((v) => v.toJson()).toList();
  }
  if (entity.descriptionItems != null) {
    data['descriptionItems'] =
        entity.descriptionItems!.map((v) => v.toJson()).toList();
  }
  return data;
}

activityDetailsCustomFieldsFromJson(
    ActivityDetailsCustomFields data, Map<String, dynamic> json) {
  if (json['standard'] != null) {
    data.standard = <ActivityDetailsCustomFieldStandard>[];
    (json['standard'] as List).forEach((v) {
      data.standard!.add(new ActivityDetailsCustomFieldStandard().fromJson(v));
    });
  }
  if (json['select'] != null) {
    data.select = <ActivityDetailsCustomFieldSelect>[];
    (json['select'] as List).forEach((v) {
      data.select!.add(new ActivityDetailsCustomFieldSelect().fromJson(v));
    });
  }
  return data;
}

Map<String, dynamic> activityDetailsCustomFieldsToJson(
    ActivityDetailsCustomFields entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  if (entity.standard != null) {
    data['standard'] = entity.standard!.map((v) => v.toJson()).toList();
  }
  if (entity.select != null) {
    data['select'] = entity.select!.map((v) => v.toJson()).toList();
  }
  return data;
}

activityDetailsCustomFieldStandardFromJson(
    ActivityDetailsCustomFieldStandard data, Map<String, dynamic> json) {
  if (json['name'] != null) {
    data.name = json['name'].toString();
  }
  if (json['info'] != null) {
    data.info = json['info'].toString();
  }
  if (json['type'] != null) {
    data.type = json['type'].toString();
  }
  if (json['required'] != null) {
    data.required = json['required'];
  }
  return data;
}

Map<String, dynamic> activityDetailsCustomFieldStandardToJson(
    ActivityDetailsCustomFieldStandard entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['name'] = entity.name;
  data['info'] = entity.info;
  data['type'] = entity.type;
  data['required'] = entity.required;
  return data;
}

activityDetailsCustomFieldSelectFromJson(
    ActivityDetailsCustomFieldSelect data, Map<String, dynamic> json) {
  if (json['name'] != null) {
    data.name = json['name'].toString();
  }
  if (json['info'] != null) {
    data.info = json['info'].toString();
  }
  if (json['required'] != null) {
    data.required = json['required'];
  }
  if (json['multiselect'] != null) {
    data.multiselect = json['multiselect'];
  }
  if (json['options'] != null) {
    data.options =
        json['options'].map((v) => v.toString()).toList().cast<String>();
  }
  return data;
}

Map<String, dynamic> activityDetailsCustomFieldSelectToJson(
    ActivityDetailsCustomFieldSelect entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['name'] = entity.name;
  data['info'] = entity.info;
  data['required'] = entity.required;
  data['multiselect'] = entity.multiselect;
  data['options'] = entity.options;
  return data;
}

activityModelActivityDetailsMediaFromJson(
    ActivityModelActivityDetailsMedia data, Map<String, dynamic> json) {
  if (json['photos'] != null) {
    data.photos = json['photos']
        .map<FileModel>(
          (value) => FileModel.fromJson(value),
        )
        .toList();
  }
  if (json['videos'] != null) {
    data.videos = json['videos']
        .map<FileModel>(
          (value) => FileModel.fromJson(value),
        )
        .toList();
  }
  if (json['cover'] != null) {
    data.cover = FileModel.fromJson(json['cover']);
  }
  if (json['previewVideo'] != null) {
    data.previewVideo = FileModel.fromJson(json['previewVideo']);
  }
  if (json['previewVideoThumbnail'] != null) {
    data.previewVideoThumbnail =
        FileModel.fromJson(json['previewVideoThumbnail']);
  }
  return data;
}

Map<String, dynamic> activityModelActivityDetailsMediaToJson(
    ActivityModelActivityDetailsMedia entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['photos'] = entity.photos;
  data['videos'] = entity.videos;
  data['cover'] = entity.cover;
  data['previewVideo'] = entity.previewVideo;
  data['previewVideoThumbnail'] = entity.previewVideoThumbnail;
  return data;
}

activityModelActivityDetailsReviewFromJson(
    ActivityModelActivityDetailsReview data, Map<String, dynamic> json) {
  if (json['_id'] != null) {
    data.sId = json['_id'].toString();
  }
  if (json['user'] != null) {
    try {
      data.userModel = new UserLoginModel().fromJson(json['user']);
      data.user = data.userModel!.sId;
    } catch (e) {
      data.user = json['user'].toString();
    }
  }
  if (json['rating'] != null) {
    data.rating = json['rating'].toInt();
  }
  if (json['description'] != null) {
    data.description = json['description'].toString();
  }
  if (json['createdAt'] != null) {
    data.createdAt = json['createdAt'].toString();
  }
  if (json['updatedAt'] != null) {
    data.updatedAt = json['updatedAt'].toString();
  }
  return data;
}

Map<String, dynamic> activityModelActivityDetailsReviewToJson(
    ActivityModelActivityDetailsReview entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['_id'] = entity.sId;
  data['user'] = entity.user;
  data['rating'] = entity.rating;
  data['description'] = entity.description;
  data['createdAt'] = entity.createdAt;
  data['updatedAt'] = entity.updatedAt;
  return data;
}

activityModelActivityCategoryFromJson(
    ActivityCategory data, Map<String, dynamic> json) {
  if (json['_id'] != null) {
    data.id = json['_id'].toString();
  }
  if (json['name'] != null) {
    data.name = json['name'].toString();
  }
  return data;
}

Map<String, dynamic> activityModelActivityCategoryToJson(
    ActivityCategory entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['_id'] = entity.id;
  data['name'] = entity.name;
  return data;
}

activityModelActivityDetailDescriptionItemModelFromJson(
    ActivityDetailDescriptionItemModel data, Map<String, dynamic> json) {
  if (json['iconId'] != null) {
    data.iconId = json['iconId'].toInt();
  }
  if (json['iconName'] != null) {
    data.iconName = json['iconName'].toString();
  }
  if (json['shortDescription'] != null) {
    data.shortDescription = json['shortDescription'].toString();
  }
  if (json['longDescription'] != null) {
    data.longDescription = json['longDescription'].toString();
  }
  return data;
}

Map<String, dynamic> activityModelActivityDetailDescriptionItemModelToJson(
    ActivityDetailDescriptionItemModel entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['iconId'] = entity.iconId;
  data['iconName'] = entity.iconName;
  data['shortDescription'] = entity.shortDescription;
  data['longDescription'] = entity.longDescription;
  return data;
}

activityVendorFromJson(ActivityVendor data, Map<String, dynamic> json) {
  if (json['_id'] != null) {
    data.id = json['_id'].toString();
  }
  if (json['name'] != null) {
    data.name = json['name'].toString();
  }
  if (json['email'] != null) {
    data.email = json['email'].toString();
  }
  if (json['createdAt'] != null) {
    data.createdAt = json['createdAt'].toString();
  }
  if (json['updatedAt'] != null) {
    data.updatedAt = json['updatedAt'].toString();
  }
  if (json['location'] != null) {
    data.location = new ActivityModelLocation().fromJson(json['location']);
  }
  return data;
}

Map<String, dynamic> activityVendorToJson(ActivityVendor entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['_id'] = entity.id;
  data['name'] = entity.name;
  data['email'] = entity.email;
  data['createdAt'] = entity.createdAt;
  data['updatedAt'] = entity.updatedAt;
  data['location'] = entity.location!.toJson();
  return data;
}
