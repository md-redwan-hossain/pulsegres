namespace Pulsegres.Worker.DataTransferObjects;

public record SystemConfig
{
    public required string MachineName { get; init; }
    public required string OsVersion { get; init; }
    public required int ProcessorCount { get; init; }
    // public required long TotalMemoryBytes { get; init; }
    // public required string ProcessorName { get; init; }
    public required int OsArchitecture { get; init; }
}