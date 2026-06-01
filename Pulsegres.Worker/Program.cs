using System.Diagnostics;
using Hardware.Info;
using Pulsegres.Worker;
using Pulsegres.Worker.DataTransferObjects;

var builder = Host.CreateApplicationBuilder(args);

var config = new SystemConfig
{
    MachineName = Environment.MachineName,
    OsVersion = Environment.OSVersion.VersionString,
    ProcessorCount = Environment.ProcessorCount,
    OsArchitecture = IntPtr.Size * 8
};

var hw = new HardwareInfo();

hw.RefreshCPUList();
hw.RefreshMemoryList();
hw.RefreshDriveList();

foreach (var cpu in hw.CpuList)
    Console.WriteLine($"CPU: {cpu.Name}, Load: {cpu.PercentProcessorTime}%");

foreach (var mem in hw.MemoryList)
    Console.WriteLine($"RAM: {mem.Capacity / 1024 / 1024} MB");

builder.Services.AddHostedService<MonitoringWorker>();


var host = builder.Build();
host.Run();