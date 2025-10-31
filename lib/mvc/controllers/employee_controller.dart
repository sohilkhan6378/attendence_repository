import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../models/employee_model.dart';
import '../../services/storage_service.dart';

/// EmployeeController कर्मचारियों की सूची व उनसे जुड़ी गतिविधियाँ संभालता है।
class EmployeeController extends GetxController {
  EmployeeController(this._storageService);

  final StorageService _storageService;

  /// कर्मचारियों की ऑब्ज़र्वेबल सूची।
  final RxList<EmployeeModel> employees = <EmployeeModel>[].obs;

  /// UI में लोडिंग दर्शाने हेतु फ़्लैग।
  final RxBool isBusy = false.obs;

  /// आरंभ में लोकल स्टोरेज से डेटा लोड किया जाता है।
  @override
  void onInit() {
    super.onInit();
    loadEmployees();
  }

  /// SharedPreferences से कर्मचारियों को पढ़कर सूची अपडेट करता है।
  void loadEmployees() {
    final List<EmployeeModel> stored = _storageService.readEmployees();
    employees.assignAll(stored);
  }

  /// नया कर्मचारी जोड़ने वाली विधि।
  Future<EmployeeModel> addEmployee({
    required String name,
    required String department,
    required String designation,
    required bool fingerprintRegistered,
    FaceTemplate? template,
    String? faceImagePath,
    String? id,
    String? employeeCode,
  }) async {
    isBusy.value = true;
    final EmployeeModel employee = EmployeeModel(
      id: id ?? const Uuid().v4(),
      name: name,
      department: department,
      designation: designation,
      employeeCode: employeeCode ??
          'EMP${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      faceTemplate: template,
      fingerprintRegistered: fingerprintRegistered,
      faceImagePath: faceImagePath,
      createdAt: DateTime.now(),
    );
    employees.add(employee);
    await _storageService.writeEmployees(employees);
    isBusy.value = false;
    return employee;
  }

  /// पहले से मौजूद कर्मचारी को अपडेट करने वाली विधि।
  Future<void> updateEmployee(EmployeeModel updated) async {
    final int index = employees.indexWhere((EmployeeModel element) => element.id == updated.id);
    if (index == -1) {
      return;
    }
    employees[index] = updated;
    employees.refresh();
    await _storageService.writeEmployees(employees);
  }

  /// आईडी के आधार पर कर्मचारी खोजने वाली हेल्पर विधि।
  EmployeeModel? employeeById(String id) {
    try {
      return employees.firstWhere((EmployeeModel element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  /// कुल कर्मचारियों की संख्या।
  int get totalEmployees => employees.length;
}
