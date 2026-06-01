namespace Pulsegres.Worker.DataTransferObjects;

public record NetworkInterface
{
    public required string Name { get; init; }
    public required long BytesSent { get; init; }
    public required long BytesReceived { get; init; }
}