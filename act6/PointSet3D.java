import java.util.*;
import java.io.*;

public class PointSet3D {
    private final List<Point3D> points = new ArrayList<>();

    public void loadFromFile(String path) throws IOException {
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;
                String[] t = line.split("\\s+|,"); // supports "x y z" or "x, y, z"
                int x = Integer.parseInt(t[0]);
                int y = Integer.parseInt(t[1]);
                int z = Integer.parseInt(t[2]);
                points.add(new Point3D(x, y, z));
            }
        }
    }

    public List<Point3D> getPoints() { return Collections.unmodifiableList(points); }

    public double minDistance() {
        double best = Double.POSITIVE_INFINITY;
        for (int i = 0; i < points.size(); i++)
            for (int j = i + 1; j < points.size(); j++)
                best = Math.min(best, points.get(i).distance(points.get(j)));
        return best;
    }

    public double maxDistance() {
        double best = Double.NEGATIVE_INFINITY;
        for (int i = 0; i < points.size(); i++)
            for (int j = i + 1; j < points.size(); j++)
                best = Math.max(best, points.get(i).distance(points.get(j)));
        return best;
    }

    public List<int[]> minDistancePairs() {
        double d = minDistance();
        List<int[]> pairs = new ArrayList<>();
        for (int i = 0; i < points.size(); i++) {
            for (int j = i + 1; j < points.size(); j++) {
                if (Math.abs(points.get(i).distance(points.get(j)) - d) <= 1e-9)
                    pairs.add(new int[]{i, j});
            }
        }
        return pairs;
    }

    public List<int[]> maxDistancePairs() {
        double d = maxDistance();
        List<int[]> pairs = new ArrayList<>();
        for (int i = 0; i < points.size(); i++) {
            for (int j = i + 1; j < points.size(); j++) {
                if (Math.abs(points.get(i).distance(points.get(j)) - d) <= 1e-9)
                    pairs.add(new int[]{i, j});
            }
        }
        return pairs;
    }

    // Heron's formula area for triangle in 3D (using distances as sides)
    public static double triangleArea(Point3D a, Point3D b, Point3D c) {
        double ab = a.distance(b);
        double bc = b.distance(c);
        double ca = c.distance(a);
        double s = (ab + bc + ca) / 2.0;
        double area2 = s * (s - ab) * (s - bc) * (s - ca);
        // Numerical guard: area2 may be slightly negative due to floating error
        return area2 <= 0 ? 0.0 : Math.sqrt(area2);
    }

    public double maxTriangleArea() {
        double best = 0.0;
        int n = points.size();
        for (int i = 0; i < n; i++)
            for (int j = i + 1; j < n; j++)
                for (int k = j + 1; k < n; k++)
                    best = Math.max(best, triangleArea(points.get(i), points.get(j), points.get(k)));
        return best;
    }

    public List<int[]> maxAreaTriples() {
        double best = maxTriangleArea();
        List<int[]> triples = new ArrayList<>();
        int n = points.size();
        for (int i = 0; i < n; i++)
            for (int j = i + 1; j < n; j++)
                for (int k = j + 1; k < n; k++) {
                    double a = triangleArea(points.get(i), points.get(j), points.get(k));
                    if (Math.abs(a - best) <= 1e-9) triples.add(new int[]{i, j, k});
                }
        return triples;
    }
}

