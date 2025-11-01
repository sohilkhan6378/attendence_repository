// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, annotate_overrides

part of 'offline_database.dart';

class PendingEvent extends DataClass implements Insertable<PendingEvent> {
  const PendingEvent({
    required this.id,
    required this.employeeId,
    required this.payload,
    required this.createdAt,
  });

  final String id;
  final String employeeId;
  final String payload;
  final DateTime createdAt;

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return <String, Expression>{
      'id': Variable<String>(id),
      'employee_id': Variable<String>(employeeId),
      'payload': Variable<String>(payload),
      'created_at': Variable<DateTime>(createdAt),
    };
  }

  PendingEventsCompanion toCompanion(bool nullToAbsent) {
    return PendingEventsCompanion(
      id: Value<String>(id),
      employeeId: Value<String>(employeeId),
      payload: Value<String>(payload),
      createdAt: Value<DateTime>(createdAt),
    );
  }

  factory PendingEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingEvent(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingEvent copyWith({
    String? id,
    String? employeeId,
    String? payload,
    DateTime? createdAt,
  }) {
    return PendingEvent(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingEvent(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, employeeId, payload, createdAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingEvent &&
          other.id == id &&
          other.employeeId == employeeId &&
          other.payload == payload &&
          other.createdAt == createdAt);
}

class PendingEventsCompanion extends UpdateCompanion<PendingEvent> {
  const PendingEventsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
  });

  PendingEventsCompanion.insert({
    required String id,
    required String employeeId,
    required String payload,
    required DateTime createdAt,
  })  : id = Value<String>(id),
        employeeId = Value<String>(employeeId),
        payload = Value<String>(payload),
        createdAt = Value<DateTime>(createdAt);

  static Insertable<PendingEvent> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PendingEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? employeeId,
    Value<String>? payload,
    Value<DateTime>? createdAt,
  }) {
    return PendingEventsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final Map<String, Expression> map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }
}

class $PendingEventsTable extends PendingEvents
    with TableInfo<$PendingEventsTable, PendingEvent> {
  $PendingEventsTable(this.attachedDatabase, [this._alias]);

  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;

  static const VerificationMeta _idMeta = VerificationMeta('id');
  static const VerificationMeta _employeeIdMeta = VerificationMeta('employeeId');
  static const VerificationMeta _payloadMeta = VerificationMeta('payload');
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');

  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );

  @override
  List<GeneratedColumn> get $columns => <GeneratedColumn>[id, employeeId, payload, createdAt];

  @override
  String get aliasedName => _alias ?? 'pending_events';

  @override
  String get actualTableName => 'pending_events';

  @override
  VerificationContext validateIntegrity(
    Insertable<PendingEvent> instance, {
    bool isInserting = false,
  }) {
    final VerificationContext context = VerificationContext();
    final Map<String, Expression> data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{id};

  @override
  PendingEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final String effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      employeeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_id'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PendingEventsTable createAlias(String alias) {
    return $PendingEventsTable(attachedDatabase, alias);
  }
}

abstract class _$OfflineDatabase extends GeneratedDatabase {
  _$OfflineDatabase(QueryExecutor e) : super(e);

  late final $PendingEventsTable pendingEvents = $PendingEventsTable(this);

  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      <TableInfo<Table, dynamic>>[pendingEvents];

  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => <DatabaseSchemaEntity>[pendingEvents];
}
