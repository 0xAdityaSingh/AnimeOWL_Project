// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_watched.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentlyWatchedAdapter extends TypeAdapter<RecentlyWatched> {
  @override
  final int typeId = 0;

  @override
  RecentlyWatched read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentlyWatched(
      title: fields[2] as String,
      malId: fields[0] as int,
      imageUrl: fields[3] as String,
      url: fields[1] as String,
      enumber: fields[4] as int,
      denumber: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RecentlyWatched obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.malId)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.enumber)
      ..writeByte(5)
      ..write(obj.denumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentlyWatchedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
