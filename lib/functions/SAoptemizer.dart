import 'dart:math';

class SimulatedAnnealing {
  final List<List<double>>
      distanceMatrix; // 2D matrix of distances between stops
  final double initialTemperature;
  final double coolingRate;
  final int numStops;

  SimulatedAnnealing(this.distanceMatrix, this.initialTemperature,
      this.coolingRate, this.numStops);

  List<int> optimizeRoute() {
    // Generate initial random route
    List<int> currentRoute = List.generate(numStops, (index) => index)
      ..shuffle();
    double currentDistance = calculateRouteDistance(currentRoute);

    List<int> bestRoute = List.from(currentRoute);
    double bestDistance = currentDistance;

    double temperature = initialTemperature;

    // Main loop
    while (temperature > 1) {
      // Create a new neighbor by swapping two stops
      List<int> newRoute = List.from(currentRoute);
      swapStops(newRoute);

      // Calculate the new distance
      double newDistance = calculateRouteDistance(newRoute);

      // Accept the new route if it's better or with a probability based on the temperature
      if (acceptanceProbability(currentDistance, newDistance, temperature) >
          Random().nextDouble()) {
        currentRoute = List.from(newRoute);
        currentDistance = newDistance;
      }

      // Update the best route found so far
      if (currentDistance < bestDistance) {
        bestRoute = List.from(currentRoute);
        bestDistance = currentDistance;
      }

      // Cool down
      temperature *= coolingRate;
    }

    return bestRoute;
  }

  double acceptanceProbability(
      double oldCost, double newCost, double temperature) {
    if (newCost < oldCost) {
      return 1.0;
    }
    return exp((oldCost - newCost) / temperature);
  }

  void swapStops(List<int> route) {
    int index1 = Random().nextInt(numStops);
    int index2 = Random().nextInt(numStops);
    int temp = route[index1];
    route[index1] = route[index2];
    route[index2] = temp;
  }

  double calculateRouteDistance(List<int> route) {
    double distance = 0.0;
    for (int i = 0; i < route.length - 1; i++) {
      distance += distanceMatrix[route[i]][route[i + 1]];
    }
    distance +=
        distanceMatrix[route.last][route.first]; // Return to start point
    return distance;
  }
}
