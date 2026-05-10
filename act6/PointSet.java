//CS 3500 - Class Point
//Works with MainPoint.java

import java.util.*;
import java.io.*;

public class PointSet {
    private final List<Point> points = new ArrayList<>();

    public void loadFromFile(String path) throws IOException {
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;
                String[] t = line.split("\\s+|,"); // supports "x y" or "x, y"
                int x = Integer.parseInt(t[0]);
                int y = Integer.parseInt(t[1]);
                points.add(new Point(x, y));
            }
        }
    }

    public List<Point> getPoints() {
        return Collections.unmodifiableList(points);
    }

    public double minDistance() {
        double best = Double.POSITIVE_INFINITY;
        for (int i = 0; i < points.size(); i++) {
            for (int j = i + 1; j < points.size(); j++) {
                best = Math.min(best, points.get(i).distance(points.get(j)));
            }
        }
        return best;
    }

    public double maxDistance() {
        double best = Double.NEGATIVE_INFINITY;
        for (int i = 0; i < points.size(); i++) {
            for (int j = i + 1; j < points.size(); j++) {
                best = Math.max(best, points.get(i).distance(points.get(j)));
            }
        }
        return best;
    }

    public List<int[]> minDistancePairs() {
        double d = minDistance();
        List<int[]> pairs = new ArrayList<>();
        for (int i = 0; i < points.size(); i++) {
            for (int j = i + 1; j < points.size(); j++) {
                if (Math.abs(points.get(i).distance(points.get(j)) - d) <= 1e-9) {
                    pairs.add(new int[]{i, j});
                }
            }
        }
        return pairs;
    }

    public List<int[]> maxDistancePairs() {
        double d = maxDistance();
        List<int[]> pairs = new ArrayList<>();
        for (int i = 0; i < points.size(); i++) {
            for (int j = i + 1; j < points.size(); j++) {
                if (Math.abs(points.get(i).distance(points.get(j)) - d) <= 1e-9) {
                    pairs.add(new int[]{i, j});
                }
            }
        }
        return pairs;
    }
}


