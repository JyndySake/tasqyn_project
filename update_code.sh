#!/bin/bash

# Path to our target file
TARGET_FILE="lib/feature/predictions/statistics_and_predictions_page.dart"

# Backup the original file
cp "$TARGET_FILE" "${TARGET_FILE}.bak"

# Update the generateFallbackData method
sed -i.tmp '/_generateFallbackData/,/^  }/c\
  // Fallback method to generate mock data if API call fails\
  List<Map<String, dynamic>> _generateFallbackData(String period) {\
    print(\'Generating fallback data for period: $period\');\
    final List<Map<String, dynamic>> data = [];\
    \
    // Using current date as the reference point\
    final now = DateTime.now();\
    final dateFormat = DateFormat(\'MMM d\');\
    final monthFormat = DateFormat(\'MMMM\'); // Full month name format\
    \
    // Generate data based on the requested period\
    if (period == \'12months\') {\
      // Generate data for each month January to December\
      for (int i = 1; i <= 12; i++) {\
        // Create date for first day of each month of current year\
        final date = DateTime(now.year, i, 1);\
        \
        // Calculate risk value as percentage (0-100%)\
        double monthRisk = 35.0 + 25.0 * sin((i - 1) * 30 * pi / 180);\
        \
        // Log for debugging\
        print(\'12months period: month=$i, date=$date, monthName=${monthFormat.format(date)}, risk=$monthRisk\');\
        \
        data.add({\
          \'date\': monthFormat.format(date),\
          \'flood_risk_month\': monthRisk,\
        });\
      }\
    } else if (period == \'30days\') {\
      // Generate daily data for the NEXT 30 days\
      for (int i = 0; i < 30; i++) {\
        final date = now.add(Duration(days: i));\
        final month = date.month;\
        final day = date.day;\
        \
        // Base risk varies by month in a sinusoidal pattern (as percentage 0-100)\
        double baseRisk = 40.0 + 20.0 * sin((month - 1) * 30 * pi / 180);\
        // Add daily variation based on day of month\
        final dailyVariation = (day % 10) * 1.5;\
        \
        data.add({\
          \'date\': dateFormat.format(date),\
          \'flood_risk\': baseRisk + dailyVariation,\
        });\
      }\
    } else if (period == \'7days\') {\
      // Generate daily data for the NEXT 7 days\
      for (int i = 0; i < 7; i++) {\
        final date = now.add(Duration(days: i));\
        final month = date.month;\
        final day = date.day;\
        \
        // Base risk varies by month in a sinusoidal pattern (as percentage 0-100)\
        double baseRisk = 40.0 + 20.0 * sin((month - 1) * 30 * pi / 180);\
        // Add daily variation based on day of month\
        final dailyVariation = (day % 5) * 2.0;\
        \
        data.add({\
          \'date\': dateFormat.format(date),\
          \'flood_risk\': baseRisk + dailyVariation,\
        });\
      }\
    }\
    \
    print("Generated fallback data for $period: ${data.map((item) => \
      period == \"12months\" ? \
        \"${item[\'date\']}: ${item[\'flood_risk_month\']}\" : \
        \"${item[\'date\']}: ${item[\'flood_risk\']}\").toList()}");\
    \
    return data;\
  }\
' "$TARGET_FILE"

# Update PredictionsAndStatisticsSection's maxY and leftTitles
sed -i.tmp '/class PredictionsAndStatisticsSection/,/maxY: 10.0,/s/maxY: 10.0,/maxY: 100.0, \/\/ Set max Y to 100% for better visualization/' "$TARGET_FILE"

# Update leftTitles in PredictionsAndStatisticsSection
sed -i.tmp '/leftTitles: AxisTitles(/,/),/c\
              leftTitles: AxisTitles(\
                sideTitles: SideTitles(\
                  showTitles: true,\
                  getTitlesWidget: (double value, TitleMeta meta) {\
                    // Show percentage labels on y-axis (0%, 25%, 50%, 75%, 100%)\
                    if (value % 25 == 0 && value <= 100) {\
                      return Text(\
                        \'${value.toInt()}%\', \
                        style: const TextStyle(\
                          color: Colors.white,\
                          fontSize: 10,\
                        ),\
                        textAlign: TextAlign.left,\
                      );\
                    }\
                    return const SizedBox.shrink();\
                  },\
                  reservedSize: 40,\
                  interval: 25, // Show labels at 25% intervals\
                ),\
              ),\
' "$TARGET_FILE"

# Update BarChartRodData in PredictionsAndStatisticsSection
sed -i.tmp '/BarChartRodData(/,/),/c\
          BarChartRodData(\
            fromY: 0,\
            toY: 35.0 + (index % 12) * 5.0, // Vary between 35-95%\
            color: Colors.amberAccent,\
            width: 18,\
            borderRadius: BorderRadius.circular(6),\
          ),\
' "$TARGET_FILE"

# Update FloodRiskLineChart maxY value
sed -i.tmp '/class _FloodRiskLineChartState/,/initState() {/c\
class _FloodRiskLineChartState extends State<FloodRiskLineChart> {\
  List<FlSpot> spots = [];\

  @override\
  void initState() {\
' "$TARGET_FILE"

sed -i.tmp '/super.initState();/,/spots =/c\
    super.initState();\
    final random = Random();\
    spots = List.generate(widget.timeLabels.length, (index) {\
      // Generate percentage-based values between 30-80%\
      return FlSpot(index.toDouble(), 30.0 + random.nextDouble() * 50.0);\
    });\
' "$TARGET_FILE"

# Update LineChartData to add maxY and leftTitles
sed -i.tmp '/LineChartData(/,/titlesData: FlTitlesData(/c\
          LineChartData(\
            gridData: FlGridData(show: true),\
            borderData: FlBorderData(show: false),\
            minY: 0,\
            maxY: 100, // Set max Y to 100% for percentage\
            titlesData: FlTitlesData(\
              leftTitles: AxisTitles(\
                sideTitles: SideTitles(\
                  showTitles: true,\
                  getTitlesWidget: (double value, TitleMeta meta) {\
                    // Show percentage labels on y-axis\
                    if (value % 25 == 0 && value <= 100) {\
                      return Text(\
                        \'${value.toInt()}%\', \
                        style: const TextStyle(\
                          color: Colors.white,\
                          fontSize: 10,\
                        ),\
                      );\
                    }\
                    return const SizedBox.shrink();\
                  },\
                  reservedSize: 40,\
                  interval: 25,\
                ),\
              ),\
' "$TARGET_FILE"

# Update the second LineChartBarData in FloodRiskLineChart
sed -i.tmp '/LineChartBarData(/,/\],/s/spots: List.generate.*/spots: List.generate(widget.timeLabels.length, (index) {\
                  \/\/ Second line with different pattern but still within 0-100% range\
                  final random = Random(index);\
                  return FlSpot(index.toDouble(), 25.0 + random.nextDouble() * 45.0);\
                }),\
                isCurved: true,\
                color: Colors.amber,\
                barWidth: 2,\
              ),\
            ],/' "$TARGET_FILE"

# Clean up temporary files
rm "${TARGET_FILE}.tmp"
