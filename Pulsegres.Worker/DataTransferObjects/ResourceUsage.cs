namespace Pulsegres.Worker.DataTransferObjects;

public record ResourceUsage
{
    public required double CpuUsagePercent { get; init; }
    public required long UsedMemoryBytes { get; init; }
    public required long AvailableMemoryBytes { get; init; }
    public required double MemoryUsagePercent { get; init; }
    public required double DiskUsagePercent { get; init; }
    public required long TotalDiskBytes { get; init; }
    public required long UsedDiskBytes { get; init; }
}