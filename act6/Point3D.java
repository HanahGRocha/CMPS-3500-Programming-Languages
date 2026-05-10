// Extends existing Point.java to add a z coordinate and 3D distance.

public class Point3D extends Point {
    private int z;

    // Default constructor
    public Point3D() {
        this(0, 0, 0);
    }

    // Full constructor
    public Point3D(int x, int y, int z) {
        super(x, y);
        setZ(z);
    }

    public int getZ() { return z; }
    public void setZ(int z) { this.z = z; }

    @Override
    public double distance(Point p) {
        if (!(p instanceof Point3D)) return super.distance(p);
        Point3D other = (Point3D) p;
        int dx = getX() - other.getX();
        int dy = getY() - other.getY();
        int dz = z - other.z;
        return Math.sqrt(dx*dx + dy*dy + dz*dz);
    }

    @Override
    public String toString() {
        return "(" + getX() + "," + getY() + "," + z + ")";
    }

    // Optional but recommended: include z in equality & hashCode.
    @Override
    public boolean equals(Object o) {
        if (o == this) return true;
        if (!(o instanceof Point3D)) return false;
        Point3D other = (Point3D) o;
        return getX() == other.getX() && getY() == other.getY() && z == other.z;
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(getX(), getY(), z);
    }
}

