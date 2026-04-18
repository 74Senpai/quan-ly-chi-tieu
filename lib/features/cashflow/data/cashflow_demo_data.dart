import 'package:flutter/material.dart';

enum CashFlowPeriod { days7, days30, days90 }

class CashFlowSnapshot {
  const CashFlowSnapshot({
    required this.currentBalanceLabel,
    required this.incomeDeltaLabel,
    required this.expenseDeltaLabel,
    required this.balanceTrendLabel,
    required this.incomeSeries,
    required this.expenseSeries,
    required this.balanceSeries,
    required this.yAxisLabels,
  });

  final String currentBalanceLabel;
  final String incomeDeltaLabel;
  final String expenseDeltaLabel;
  final String balanceTrendLabel;
  final List<double> incomeSeries;
  final List<double> expenseSeries;
  final List<double> balanceSeries;
  final List<String> yAxisLabels;
}

class CashFlowLegendItem {
  const CashFlowLegendItem({
    required this.label,
    required this.color,
    this.dashed = false,
  });

  final String label;
  final Color color;
  final bool dashed;
}

const cashFlowLegend = <CashFlowLegendItem>[
  CashFlowLegendItem(label: 'THU NHẬP', color: Color(0xFF006D4A)),
  CashFlowLegendItem(label: 'CHI TIÊU', color: Color(0xFF9F403D)),
  CashFlowLegendItem(label: 'SỐ DƯ', color: Color(0xFF0053DB), dashed: true),
];

const cashFlowSnapshots = <CashFlowPeriod, CashFlowSnapshot>{
  CashFlowPeriod.days7: CashFlowSnapshot(
    currentBalanceLabel: '128.500.000đ',
    incomeDeltaLabel: '+12.4M',
    expenseDeltaLabel: '-5.2M',
    balanceTrendLabel: '+2.4M',
    incomeSeries: [3.0, 3.6, 3.4, 5.1, 4.8, 6.5, 5.6],
    expenseSeries: [2.2, 2.6, 1.4, 1.8, 2.1, 3.3, 2.8],
    balanceSeries: [6.0, 5.8, 6.8, 8.5, 7.8, 10.2, 11.3],
    yAxisLabels: ['0', '5M', '10M', '15M'],
  ),
  CashFlowPeriod.days30: CashFlowSnapshot(
    currentBalanceLabel: '42.500.000đ',
    incomeDeltaLabel: '+12.450.000đ',
    expenseDeltaLabel: '-8.450.000đ',
    balanceTrendLabel: '+2.4M',
    incomeSeries: [3.0, 4.5, 3.8, 7.6, 6.8, 9.2],
    expenseSeries: [2.2, 3.0, 1.2, 2.0, 4.4, 3.6],
    balanceSeries: [6.0, 7.2, 8.6, 10.4, 11.6, 12.6],
    yAxisLabels: ['0', '5M', '10M', '15M'],
  ),
  CashFlowPeriod.days90: CashFlowSnapshot(
    currentBalanceLabel: '42.500.000đ',
    incomeDeltaLabel: '+28.450.000đ',
    expenseDeltaLabel: '-21.300.000đ',
    balanceTrendLabel: '+7.1M',
    incomeSeries: [3.0, 4.0, 4.8, 5.2, 6.1, 6.5, 7.4, 7.8],
    expenseSeries: [2.2, 2.8, 2.1, 2.6, 3.4, 3.9, 4.1, 3.7],
    balanceSeries: [6.0, 6.6, 7.8, 8.0, 9.2, 10.0, 11.1, 11.8],
    yAxisLabels: ['0', '5M', '10M', '15M'],
  ),
};
