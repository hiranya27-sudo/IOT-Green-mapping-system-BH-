import 'package:flutter/material.dart';

// ─── Data Models ───────────────────────────────────────────────
class TimetableSlot {
  final String startTime;
  final String endTime;
  final String moduleCode;
  final String moduleName;
  final String lecturer;
  final String degrees;

  const TimetableSlot({
    required this.startTime,
    required this.endTime,
    required this.moduleCode,
    required this.moduleName,
    required this.lecturer,
    required this.degrees,
  });
}

class TimetableDay {
  final DateTime date;
  final List<TimetableSlot> slots;
  final String? specialNote;

  const TimetableDay({
    required this.date,
    required this.slots,
    this.specialNote,
  });
}

// ─── Module Info Lookup ────────────────────────────────────────
const Map<String, Map<String, String>> _moduleInfo = {
  'PUSL2021': {
    'name': 'Computing Group Project',
    'lecturer': 'Mr. Diluka Wijesinghe / Ms. Sanuli Weerasinghe',
  },
  'PUSL2022': {
    'name': 'Introduction to IoT',
    'lecturer': 'Mr. Isuru Bandara / Mr. Supun Gajendrasinghe',
  },
  'PUSL2023': {
    'name': 'Mobile Application Development',
    'lecturer': 'Mr. Diluka Wijesinghe',
  },
  'PUSL2020': {
    'name': 'Software Development Tools and Practices',
    'lecturer': 'Ms. Pavithra Subhashini / Mr. Anton Jayakody',
  },
  'PUSL2025': {
    'name': 'Security Architecture and Cryptography',
    'lecturer': 'Dr. Pabudhi Abeyrathne',
  },
  'PUSL2052': {
    'name': 'Business Process and ERP',
    'lecturer': 'Ms. Lakni Peris / Ms. Dharani Rajasinghe',
  },
  'PUSL2065': {
    'name': 'Computer Networks',
    'lecturer': 'Mr. Chamindra Attanayeka',
  },
  'PUSL2077': {'name': 'Data Science in Python', 'lecturer': 'Ms. Lakni Peris'},
  'PUSL2078': {
    'name': 'Statistics for Data Science',
    'lecturer': 'Ms. Kavisha Rajapaksha',
  },
  'PUSL2079': {
    'name': 'Topics in Business Analytics and Intelligence',
    'lecturer': 'Ms. Dharani Rajasinghe',
  },
  'PUSL2100': {
    'name': 'Evolutionary Computing',
    'lecturer': 'Mr. Anton Jayakody',
  },
  'PUSL2101': {
    'name': 'Computer Vision & Image Processing',
    'lecturer': 'Dr. Rasika Ranaweera / Ms. Chathurma Wijesinghe',
  },
};

// ─── Full Timetable Data ───────────────────────────────────────
final List<TimetableDay> _timetable = [
  // ── Week 1 ──────────────────────────────────────────────────
  TimetableDay(
    date: DateTime(2026, 2, 2),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2052',
        moduleName: 'Business Process and ERP',
        lecturer: 'Ms. Lakni Peris / Ms. Dharani Rajasinghe',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2078',
        moduleName: 'Statistics for Data Science',
        lecturer: 'Ms. Kavisha Rajapaksha',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2100',
        moduleName: 'Evolutionary Computing',
        lecturer: 'Mr. Anton Jayakody',
        degrees: 'AI',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2077',
        moduleName: 'Data Science in Python',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'DS',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 2, 4),
    specialNote: 'Independence Day — No Classes',
    slots: [],
  ),
  TimetableDay(
    date: DateTime(2026, 2, 6),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2079',
        moduleName: 'Topics in Business Analytics',
        lecturer: 'Ms. Dharani Rajasinghe',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2022',
        moduleName: 'Introduction to IoT',
        lecturer: 'Mr. Isuru Bandara / Mr. Supun Gajendrasinghe',
        degrees: 'SE/CS/CN/SEC',
      ),
    ],
  ),

  // ── Week 2 ──────────────────────────────────────────────────
  TimetableDay(
    date: DateTime(2026, 2, 9),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2078',
        moduleName: 'Statistics for Data Science',
        lecturer: 'Ms. Kavisha Rajapaksha',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2100',
        moduleName: 'Evolutionary Computing',
        lecturer: 'Mr. Anton Jayakody',
        degrees: 'AI',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2077',
        moduleName: 'Data Science in Python',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'DS',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 2, 10),
    slots: [
      TimetableSlot(
        startTime: '2:00 PM',
        endTime: '3:00 PM',
        moduleCode: 'PUSL2101',
        moduleName: 'Computer Vision & Image Processing',
        lecturer: 'Dr. Rasika Ranaweera',
        degrees: 'AI',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 2, 11),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2065',
        moduleName: 'Computer Networks',
        lecturer: 'Mr. Chamindra Attanayeka',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2023',
        moduleName: 'Mobile Application Development',
        lecturer: 'Mr. Diluka Wijesinghe',
        degrees: 'SE/CS',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 2, 12),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2052',
        moduleName: 'Business Process and ERP',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2065',
        moduleName: 'Computer Networks',
        lecturer: 'Mr. Chamindra Attanayeka',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2023',
        moduleName: 'Mobile Application Development',
        lecturer: 'Mr. Diluka Wijesinghe',
        degrees: 'SE/CS',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 2, 13),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2079',
        moduleName: 'Topics in Business Analytics',
        lecturer: 'Ms. Dharani Rajasinghe',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2022',
        moduleName: 'Introduction to IoT',
        lecturer: 'Mr. Isuru Bandara',
        degrees: 'SE/CS/CN/SEC',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2020',
        moduleName: 'Software Development Tools',
        lecturer: 'Ms. Pavithra Subhashini',
        degrees: 'SE/CS/TM',
      ),
    ],
  ),

  // ── Week 3 ──────────────────────────────────────────────────
  TimetableDay(
    date: DateTime(2026, 2, 16),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2078',
        moduleName: 'Statistics for Data Science',
        lecturer: 'Ms. Kavisha Rajapaksha',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2100',
        moduleName: 'Evolutionary Computing',
        lecturer: 'Mr. Anton Jayakody',
        degrees: 'AI',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2077',
        moduleName: 'Data Science in Python',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'DS',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 2, 17),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2022',
        moduleName: 'Introduction to IoT — Lab',
        lecturer: 'Mr. Isuru Bandara',
        degrees: 'SE/CS/CN/SEC',
      ),
      TimetableSlot(
        startTime: '2:00 PM',
        endTime: '3:00 PM',
        moduleCode: 'PUSL2101',
        moduleName: 'Computer Vision & Image Processing',
        lecturer: 'Dr. Rasika Ranaweera',
        degrees: 'AI',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 2, 18),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2025',
        moduleName: 'Security Architecture and Cryptography',
        lecturer: 'Dr. Pabudhi Abeyrathne',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2065',
        moduleName: 'Computer Networks',
        lecturer: 'Mr. Chamindra Attanayeka',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2023',
        moduleName: 'Mobile Application Development',
        lecturer: 'Mr. Diluka Wijesinghe',
        degrees: 'SE/CS',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 2, 19),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2052',
        moduleName: 'Business Process and ERP',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2025',
        moduleName: 'Security Architecture and Cryptography',
        lecturer: 'Dr. Pabudhi Abeyrathne',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '5:00 PM',
        moduleCode: 'PUSL2023',
        moduleName: 'Mobile Application Development',
        lecturer: 'Mr. Diluka Wijesinghe',
        degrees: 'SE/CS',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2065',
        moduleName: 'Computer Networks',
        lecturer: 'Mr. Chamindra Attanayeka',
        degrees: 'CN/SEC',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 2, 20),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2079',
        moduleName: 'Topics in Business Analytics',
        lecturer: 'Ms. Dharani Rajasinghe',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2022',
        moduleName: 'Introduction to IoT',
        lecturer: 'Mr. Isuru Bandara',
        degrees: 'SE/CS/CN/SEC',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2020',
        moduleName: 'Software Development Tools',
        lecturer: 'Ms. Pavithra Subhashini',
        degrees: 'SE/CS/TM',
      ),
    ],
  ),

  // ── Week 4 ──────────────────────────────────────────────────
  TimetableDay(
    date: DateTime(2026, 2, 23),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2078',
        moduleName: 'Statistics for Data Science',
        lecturer: 'Ms. Kavisha Rajapaksha',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2100',
        moduleName: 'Evolutionary Computing',
        lecturer: 'Mr. Anton Jayakody',
        degrees: 'AI',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2077',
        moduleName: 'Data Science in Python',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'DS',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 2, 24),
    slots: [
      TimetableSlot(
        startTime: '2:00 PM',
        endTime: '3:00 PM',
        moduleCode: 'PUSL2101',
        moduleName: 'Computer Vision & Image Processing',
        lecturer: 'Dr. Rasika Ranaweera',
        degrees: 'AI',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 2, 25),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2025',
        moduleName: 'Security Architecture and Cryptography',
        lecturer: 'Dr. Pabudhi Abeyrathne',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '12:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2022',
        moduleName: 'Introduction to IoT (SE)',
        lecturer: 'Mr. Isuru Bandara',
        degrees: 'SE',
      ),
      TimetableSlot(
        startTime: '2:00 PM',
        endTime: '4:00 PM',
        moduleCode: 'PUSL2022',
        moduleName: 'Introduction to IoT (CS/CN/SEC)',
        lecturer: 'Mr. Isuru Bandara',
        degrees: 'CS/CN/SEC',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 2, 26),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2025',
        moduleName: 'Security Architecture and Cryptography',
        lecturer: 'Dr. Pabudhi Abeyrathne',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2052',
        moduleName: 'Business Process and ERP',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2065',
        moduleName: 'Computer Networks',
        lecturer: 'Mr. Chamindra Attanayeka',
        degrees: 'CN/SEC',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 2, 27),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2079',
        moduleName: 'Topics in Business Analytics',
        lecturer: 'Ms. Dharani Rajasinghe',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2065',
        moduleName: 'Computer Networks',
        lecturer: 'Mr. Chamindra Attanayeka',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2023',
        moduleName: 'Mobile Application Development',
        lecturer: 'Mr. Diluka Wijesinghe',
        degrees: 'SE/CS',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2020',
        moduleName: 'Software Development Tools',
        lecturer: 'Ms. Pavithra Subhashini',
        degrees: 'SE/CS/TM',
      ),
    ],
  ),

  // ── Week 5 ──────────────────────────────────────────────────
  TimetableDay(
    date: DateTime(2026, 3, 2),
    specialNote: 'Poya Day — No Classes',
    slots: [],
  ),
  TimetableDay(
    date: DateTime(2026, 3, 3),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2078',
        moduleName: 'Statistics for Data Science',
        lecturer: 'Ms. Kavisha Rajapaksha',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '3:00 PM',
        moduleCode: 'PUSL2078',
        moduleName: 'Statistics for Data Science',
        lecturer: 'Ms. Kavisha Rajapaksha',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '2:00 PM',
        endTime: '3:00 PM',
        moduleCode: 'PUSL2101',
        moduleName: 'Computer Vision & Image Processing',
        lecturer: 'Dr. Rasika Ranaweera',
        degrees: 'AI',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 3, 4),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2025',
        moduleName: 'Security Architecture and Cryptography',
        lecturer: 'Dr. Pabudhi Abeyrathne',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2065',
        moduleName: 'Computer Networks',
        lecturer: 'Mr. Chamindra Attanayeka',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2023',
        moduleName: 'Mobile Application Development',
        lecturer: 'Mr. Diluka Wijesinghe',
        degrees: 'SE/CS',
      ),
      TimetableSlot(
        startTime: '3:00 PM',
        endTime: '4:00 PM',
        moduleCode: 'PUSL2021',
        moduleName: 'Computing Group Project',
        lecturer: 'Mr. Diluka Wijesinghe',
        degrees: 'ALL',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 3, 5),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2025',
        moduleName: 'Security Architecture and Cryptography',
        lecturer: 'Dr. Pabudhi Abeyrathne',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2052',
        moduleName: 'Business Process and ERP',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2020',
        moduleName: 'Software Development Tools',
        lecturer: 'Mr. Anton Jayakody',
        degrees: 'SE/CS/TM',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 3, 6),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2079',
        moduleName: 'Topics in Business Analytics',
        lecturer: 'Ms. Dharani Rajasinghe',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2022',
        moduleName: 'Introduction to IoT',
        lecturer: 'Mr. Isuru Bandara',
        degrees: 'SE/CS/CN/SEC',
      ),
    ],
  ),

  // ── Week 6 ──────────────────────────────────────────────────
  TimetableDay(
    date: DateTime(2026, 3, 9),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2078',
        moduleName: 'Statistics for Data Science',
        lecturer: 'Ms. Kavisha Rajapaksha',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2100',
        moduleName: 'Evolutionary Computing',
        lecturer: 'Mr. Anton Jayakody',
        degrees: 'AI',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2077',
        moduleName: 'Data Science in Python',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'DS',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 3, 10),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2101',
        moduleName: 'Computer Vision & Image Processing',
        lecturer: 'Dr. Rasika Ranaweera',
        degrees: 'AI',
      ),
      TimetableSlot(
        startTime: '2:00 PM',
        endTime: '3:00 PM',
        moduleCode: 'PUSL2101',
        moduleName: 'Computer Vision & Image Processing',
        lecturer: 'Dr. Rasika Ranaweera',
        degrees: 'AI',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 3, 11),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2025',
        moduleName: 'Security Architecture and Cryptography',
        lecturer: 'Dr. Pabudhi Abeyrathne',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2065',
        moduleName: 'Computer Networks',
        lecturer: 'Mr. Chamindra Attanayeka',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2023',
        moduleName: 'Mobile Application Development',
        lecturer: 'Mr. Diluka Wijesinghe',
        degrees: 'SE/CS',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 3, 12),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2025',
        moduleName: 'Security Architecture and Cryptography',
        lecturer: 'Dr. Pabudhi Abeyrathne',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2052',
        moduleName: 'Business Process and ERP',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2079',
        moduleName: 'Topics in Business Analytics',
        lecturer: 'Ms. Dharani Rajasinghe',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2022',
        moduleName: 'Introduction to IoT',
        lecturer: 'Mr. Isuru Bandara',
        degrees: 'SE/CS/CN/SEC',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 3, 13),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2079',
        moduleName: 'Topics in Business Analytics',
        lecturer: 'Ms. Dharani Rajasinghe',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2022',
        moduleName: 'Introduction to IoT',
        lecturer: 'Mr. Isuru Bandara',
        degrees: 'SE/CS/CN/SEC',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2020',
        moduleName: 'Software Development Tools',
        lecturer: 'Mr. Anton Jayakody',
        degrees: 'SE/CS/TM',
      ),
    ],
  ),

  // ── Week 7 ──────────────────────────────────────────────────
  TimetableDay(
    date: DateTime(2026, 3, 16),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2078',
        moduleName: 'Statistics for Data Science',
        lecturer: 'Ms. Kavisha Rajapaksha',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2065',
        moduleName: 'Computer Networks',
        lecturer: 'Mr. Chamindra Attanayeka',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2100',
        moduleName: 'Evolutionary Computing',
        lecturer: 'Mr. Anton Jayakody',
        degrees: 'AI',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2077',
        moduleName: 'Data Science in Python',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2065',
        moduleName: 'Computer Networks — Practical',
        lecturer: 'Mr. Chamindra Attanayeka',
        degrees: 'CN/SEC',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 3, 17),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2101',
        moduleName: 'Computer Vision & Image Processing',
        lecturer: 'Dr. Rasika Ranaweera',
        degrees: 'AI',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2077',
        moduleName: 'Data Science in Python',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '4:00 PM',
        moduleCode: 'PUSL2078',
        moduleName: 'Statistics for Data Science',
        lecturer: 'Ms. Kavisha Rajapaksha',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '2:00 PM',
        endTime: '5:00 PM',
        moduleCode: 'PUSL2100',
        moduleName: 'Evolutionary Computing',
        lecturer: 'Mr. Anton Jayakody',
        degrees: 'AI',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 3, 19),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2025',
        moduleName: 'Security Architecture and Cryptography',
        lecturer: 'Dr. Pabudhi Abeyrathne',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2052',
        moduleName: 'Business Process and ERP',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2065',
        moduleName: 'Computer Networks',
        lecturer: 'Mr. Chamindra Attanayeka',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2023',
        moduleName: 'Mobile Application Development',
        lecturer: 'Mr. Diluka Wijesinghe',
        degrees: 'SE/CS',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 3, 20),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2079',
        moduleName: 'Topics in Business Analytics',
        lecturer: 'Ms. Dharani Rajasinghe',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2022',
        moduleName: 'Introduction to IoT',
        lecturer: 'Mr. Isuru Bandara',
        degrees: 'SE/CS/CN/SEC',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2020',
        moduleName: 'Software Development Tools',
        lecturer: 'Mr. Anton Jayakody',
        degrees: 'SE/CS/TM',
      ),
    ],
  ),

  // ── Week 8 ──────────────────────────────────────────────────
  TimetableDay(
    date: DateTime(2026, 3, 23),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2052',
        moduleName: 'Business Process and ERP',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2078',
        moduleName: 'Statistics for Data Science',
        lecturer: 'Ms. Kavisha Rajapaksha',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2100',
        moduleName: 'Evolutionary Computing',
        lecturer: 'Mr. Anton Jayakody',
        degrees: 'AI',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2077',
        moduleName: 'Data Science in Python',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2025',
        moduleName: 'Security Architecture and Cryptography',
        lecturer: 'Dr. Pabudhi Abeyrathne',
        degrees: 'CN/SEC',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 3, 24),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2052',
        moduleName: 'Business Process and ERP',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2078',
        moduleName: 'Statistics for Data Science',
        lecturer: 'Ms. Kavisha Rajapaksha',
        degrees: 'DS',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 3, 26),
    specialNote: 'PUSL2021 VIVA',
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2021',
        moduleName: 'Computing Group Project — VIVA',
        lecturer: 'Mr. Diluka Wijesinghe',
        degrees: 'ALL',
      ),
    ],
  ),

  // ── Week 9 ──────────────────────────────────────────────────
  TimetableDay(
    date: DateTime(2026, 3, 30),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2052',
        moduleName: 'Business Process and ERP',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2100',
        moduleName: 'Evolutionary Computing',
        lecturer: 'Mr. Anton Jayakody',
        degrees: 'AI',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2077',
        moduleName: 'Data Science in Python',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'DS',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 3, 31),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2100',
        moduleName: 'Evolutionary Computing',
        lecturer: 'Mr. Anton Jayakody',
        degrees: 'AI',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2077',
        moduleName: 'Data Science in Python',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '4:00 PM',
        moduleCode: 'PUSL2078',
        moduleName: 'Statistics for Data Science',
        lecturer: 'Ms. Kavisha Rajapaksha',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '2:00 PM',
        endTime: '3:00 PM',
        moduleCode: 'PUSL2101',
        moduleName: 'Computer Vision & Image Processing',
        lecturer: 'Dr. Rasika Ranaweera',
        degrees: 'AI',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 1),
    specialNote: 'Poya Day — No Classes',
    slots: [],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 2),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2079',
        moduleName: 'Topics in Business Analytics',
        lecturer: 'Ms. Dharani Rajasinghe',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2022',
        moduleName: 'Introduction to IoT',
        lecturer: 'Mr. Isuru Bandara',
        degrees: 'SE/CS/CN/SEC',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2077',
        moduleName: 'Data Science in Python — Viva',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2020',
        moduleName: 'Software Development Tools — Automation',
        lecturer: 'Ms. Pavithra Subhashini',
        degrees: 'SE/CS/TM',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2077',
        moduleName: 'Data Science in Python — Viva',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'DS',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 3),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2079',
        moduleName: 'Topics in Business Analytics',
        lecturer: 'Ms. Dharani Rajasinghe',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2022',
        moduleName: 'Introduction to IoT',
        lecturer: 'Mr. Isuru Bandara',
        degrees: 'SE/CS/CN/SEC',
      ),
      TimetableSlot(
        startTime: '1:00 PM',
        endTime: '2:00 PM',
        moduleCode: 'PUSL2020',
        moduleName: 'Software Development Tools',
        lecturer: 'Ms. Pavithra Subhashini',
        degrees: 'SE/CS/TM',
      ),
    ],
  ),

  // ── Week 10 ─────────────────────────────────────────────────
  TimetableDay(
    date: DateTime(2026, 4, 6),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2052',
        moduleName: 'Business Process and ERP — Coursework Submission',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'TM',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 7),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2101',
        moduleName: 'Computer Vision — Coursework Submission',
        lecturer: 'Dr. Rasika Ranaweera',
        degrees: 'AI',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 8),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2078',
        moduleName: 'Statistics for Data Science — Coursework Submission',
        lecturer: 'Ms. Kavisha Rajapaksha',
        degrees: 'DS',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 9),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2100',
        moduleName: 'Evolutionary Computing — Coursework Submission',
        lecturer: 'Mr. Anton Jayakody',
        degrees: 'AI',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2077',
        moduleName: 'Data Science in Python — Coursework Submission',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2023',
        moduleName: 'Mobile App Dev — Coursework Submission',
        lecturer: 'Mr. Diluka Wijesinghe',
        degrees: 'SE/CS',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 10),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2100',
        moduleName: 'Evolutionary Computing — Viva',
        lecturer: 'Mr. Anton Jayakody',
        degrees: 'AI',
      ),
    ],
  ),

  // ── Week 17 — Sinhala & Tamil New Year ──────────────────────
  TimetableDay(
    date: DateTime(2026, 4, 13),
    specialNote: 'Sinhala & Tamil New Year Holidays',
    slots: [],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 14),
    specialNote: 'Sinhala & Tamil New Year Holidays',
    slots: [],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 15),
    specialNote: 'Sinhala & Tamil New Year Holidays',
    slots: [],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 16),
    specialNote: 'Sinhala & Tamil New Year Holidays',
    slots: [],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 17),
    specialNote: 'Sinhala & Tamil New Year Holidays',
    slots: [],
  ),

  // ── Week 18 ─────────────────────────────────────────────────
  TimetableDay(
    date: DateTime(2026, 4, 20),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2020',
        moduleName: 'Software Development Tools — Coursework Submission',
        lecturer: 'Ms. Pavithra Subhashini',
        degrees: 'SE/CS/TM',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2025',
        moduleName: 'Security Architecture — Coursework Submission',
        lecturer: 'Dr. Pabudhi Abeyrathne',
        degrees: 'CN/SEC',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 21),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2022',
        moduleName: 'Introduction to IoT — Coursework Submission',
        lecturer: 'Mr. Isuru Bandara',
        degrees: 'SE/CS/CN/SEC',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2079',
        moduleName: 'Topics in Business Analytics — Coursework Submission',
        lecturer: 'Ms. Dharani Rajasinghe',
        degrees: 'TM',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 22),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2065',
        moduleName: 'Computer Networks — Coursework Submission',
        lecturer: 'Mr. Chamindra Attanayeka',
        degrees: 'CN/SEC',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 23),
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '10:00 AM',
        moduleCode: 'PUSL2022',
        moduleName: 'Introduction to IoT — Viva',
        lecturer: 'Mr. Isuru Bandara',
        degrees: 'SE/CS/CN/SEC',
      ),
    ],
  ),

  // ── Week 19 — Study Leave ────────────────────────────────────
  TimetableDay(
    date: DateTime(2026, 4, 27),
    specialNote: 'Study Leave',
    slots: [],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 28),
    specialNote: 'Study Leave',
    slots: [],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 29),
    specialNote: 'Study Leave',
    slots: [],
  ),
  TimetableDay(
    date: DateTime(2026, 4, 30),
    specialNote: 'Study Leave',
    slots: [],
  ),
  TimetableDay(
    date: DateTime(2026, 5, 1),
    specialNote: 'Study Leave',
    slots: [],
  ),

  // ── Week 20 — Exams ─────────────────────────────────────────
  TimetableDay(
    date: DateTime(2026, 5, 4),
    specialNote: 'Exam Day',
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '12:00 PM',
        moduleCode: 'PUSL2077',
        moduleName: 'Data Science in Python — Exam',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'DS',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '12:00 PM',
        moduleCode: 'PUSL2025',
        moduleName: 'Security Architecture — Exam',
        lecturer: 'Dr. Pabudhi Abeyrathne',
        degrees: 'CN/SEC',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 5, 5),
    specialNote: 'Exam Day',
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '12:00 PM',
        moduleCode: 'PUSL2100',
        moduleName: 'Evolutionary Computing — Exam',
        lecturer: 'Mr. Anton Jayakody',
        degrees: 'AI',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '12:00 PM',
        moduleCode: 'PUSL2052',
        moduleName: 'Business Process and ERP — Exam',
        lecturer: 'Ms. Lakni Peris',
        degrees: 'TM',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 5, 7),
    specialNote: 'Exam Day',
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '12:00 PM',
        moduleCode: 'PUSL2065',
        moduleName: 'Computer Networks — Exam',
        lecturer: 'Mr. Chamindra Attanayeka',
        degrees: 'CN/SEC',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '12:00 PM',
        moduleCode: 'PUSL2078',
        moduleName: 'Statistics for Data Science — Exam',
        lecturer: 'Ms. Kavisha Rajapaksha',
        degrees: 'DS',
      ),
    ],
  ),
  TimetableDay(
    date: DateTime(2026, 5, 8),
    specialNote: 'Exam Day',
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '12:00 PM',
        moduleCode: 'PUSL2079',
        moduleName: 'Topics in Business Analytics — Exam',
        lecturer: 'Ms. Dharani Rajasinghe',
        degrees: 'TM',
      ),
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '12:00 PM',
        moduleCode: 'PUSL2101',
        moduleName: 'Computer Vision — Exam',
        lecturer: 'Dr. Rasika Ranaweera',
        degrees: 'AI',
      ),
    ],
  ),

  // ── Week 21 — Final Exam ─────────────────────────────────────
  TimetableDay(
    date: DateTime(2026, 5, 11),
    specialNote: 'Exam Day',
    slots: [
      TimetableSlot(
        startTime: '9:00 AM',
        endTime: '12:00 PM',
        moduleCode: 'PUSL2020',
        moduleName: 'Software Development Tools — Exam',
        lecturer: 'Ms. Pavithra Subhashini',
        degrees: 'SE/CS/TM',
      ),
    ],
  ),
];

// ══════════════════════════════════════════════════════════════
class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  late DateTime _selectedDate;
  late PageController _pageController;
  late List<DateTime> _availableDates;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _availableDates = _timetable.map((d) => d.date).toList();
    _selectedDate = _findClosestDate();
    _currentIndex = _availableDates.indexOf(_selectedDate);
    _pageController = PageController(initialPage: _currentIndex);
  }

  DateTime _findClosestDate() {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    for (final date in _availableDates) {
      if (!date.isBefore(todayOnly)) return date;
    }
    return _availableDates.last;
  }

  TimetableDay _getDayData(DateTime date) {
    return _timetable.firstWhere(
      (d) =>
          d.date.year == date.year &&
          d.date.month == date.month &&
          d.date.day == date.day,
      orElse: () => TimetableDay(date: date, slots: []),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final todayIndex = _availableDates.indexWhere((d) => _isToday(d));
              if (todayIndex != -1) {
                _pageController.animateToPage(
                  todayIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Text(
              'Today',
              style: TextStyle(
                color: isDark ? Colors.blue[300] : Colors.blue[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Timetable',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'BSc Stage 2 Semester 2 — Batch 13',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // ─── Date Selector Strip ─────────────────────────────
          SizedBox(
            height: 72,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _availableDates.length,
              itemBuilder: (context, index) {
                final date = _availableDates[index];
                final isSelected = index == _currentIndex;
                final isToday = _isToday(date);
                const months = [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'May',
                  'Jun',
                  'Jul',
                  'Aug',
                  'Sep',
                  'Oct',
                  'Nov',
                  'Dec',
                ];
                const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    width: 52,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? Colors.blue[700] : Colors.blue[600])
                          : isToday
                          ? (isDark
                                ? Colors.blue.withOpacity(0.15)
                                : Colors.blue.withOpacity(0.08))
                          : (isDark
                                ? const Color(0xFF2C2C2C)
                                : const Color(0xFFF1F3F5)),
                      borderRadius: BorderRadius.circular(14),
                      border: isToday && !isSelected
                          ? Border.all(
                              color: isDark
                                  ? Colors.blue[400]!
                                  : Colors.blue[400]!,
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          days[date.weekday - 1],
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected ? Colors.white : Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : isDark
                                ? const Color(0xFFE0E0E0)
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                        Text(
                          months[date.month - 1],
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? Colors.white70
                                : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // ─── Day Content ─────────────────────────────────────
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _availableDates.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  _selectedDate = _availableDates[index];
                });
              },
              itemBuilder: (context, index) {
                final date = _availableDates[index];
                final dayData = _getDayData(date);
                return _buildDayContent(dayData, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─── Day Content ───────────────────────────────────────────
  Widget _buildDayContent(TimetableDay day, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date label
          Text(
            _formatDate(day.date),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),

          const SizedBox(height: 16),

          // Special note banner
          if (day.specialNote != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.orange.withOpacity(0.15)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Colors.orange[700]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      day.specialNote!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // No slots
          if (day.slots.isEmpty && day.specialNote == null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2C2C2C)
                    : const Color(0xFFF1F3F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.event_available_outlined,
                    size: 40,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No classes scheduled',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Slots
          ...day.slots.map((slot) => _buildSlotCard(slot, isDark)),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ─── Slot Card ─────────────────────────────────────────────
  Widget _buildSlotCard(TimetableSlot slot, bool isDark) {
    final bool isCurrentSlot = _isCurrentSlot(slot);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentSlot
            ? (isDark
                  ? Colors.blue.withOpacity(0.15)
                  : Colors.blue.withOpacity(0.07))
            : (isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5)),
        borderRadius: BorderRadius.circular(16),
        border: isCurrentSlot
            ? Border.all(
                color: isDark ? Colors.blue[400]! : Colors.blue[400]!,
                width: 1.5,
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time column
          SizedBox(
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slot.startTime,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isCurrentSlot
                        ? (isDark ? Colors.blue[300] : Colors.blue[700])
                        : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                ),
                Text(
                  slot.endTime,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                if (isCurrentSlot) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Now',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Divider line
          Container(
            width: 1.5,
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isCurrentSlot
                  ? Colors.blue
                  : (isDark ? const Color(0xFF3A3A3A) : Colors.grey[300]),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF3A3A3A) : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        slot.moduleCode,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.grey[300]
                              : const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        slot.degrees,
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  slot.moduleName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 13,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        slot.lecturer,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isCurrentSlot(TimetableSlot slot) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    if (today != selectedDay) return false;

    int parseHour(String time) {
      final parts = time.replaceAll(' AM', '').replaceAll(' PM', '').split(':');
      int h = int.parse(parts[0]);
      if (time.contains('PM') && h != 12) h += 12;
      if (time.contains('AM') && h == 12) h = 0;
      return h;
    }

    final startH = parseHour(slot.startTime);
    final endH = parseHour(slot.endTime);
    final nowH = now.hour;

    return nowH >= startH && nowH < endH;
  }
}
