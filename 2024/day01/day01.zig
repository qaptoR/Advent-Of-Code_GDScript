const std = @import("std");

const Allocator = std.mem.Allocator;

// const TEST_FILE = "D:/Files/advent/2024/day01/test01.txt";
const DATA_FILE = "D:/Files/advent/2024/day01/data01.txt";

fn loadData(allocator: Allocator, filename: []const u8) !std.ArrayList(std.ArrayList(i32)) {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();
    const content = try file.readToEndAlloc(allocator, std.math.maxInt(u64));
    defer allocator.free(content);

    var data = std.ArrayList(std.ArrayList(i32)).init(allocator);

    var rows = std.mem.splitSequence(u8, content, "\r\n");
    while (rows.next()) |row| {
        if (row.len == 0) continue;
        var row_data = try std.ArrayList(i32).initCapacity(allocator, 2);
        var cols = std.mem.split(u8, row, "   ");

        while (cols.next()) |col| {
            try row_data.append(try std.fmt.parseInt(i32, col, 10));
        }
        try data.append(row_data);
    }

    return data;
}

fn test_data1(allocator: Allocator, data: std.ArrayList(std.ArrayList(i32))) !void {
    const time_start = std.time.milliTimestamp();

    var sum: u32 = 0;
    var lists = try std.ArrayList(std.ArrayList(i32)).initCapacity(allocator, 2);

    var list0 = std.ArrayList(i32).init(allocator);
    var list1 = std.ArrayList(i32).init(allocator);
    for (data.items) |row| {
        try list0.append(row.items[0]);
        try list1.append(row.items[1]);
    }
    try lists.append(list0);
    try lists.append(list1);

    var i: u32 = 0;
    const len: usize = lists.items[0].items.len;
    std.mem.sort(i32, lists.items[0].items, {}, comptime std.sort.desc(i32));
    std.mem.sort(i32, lists.items[1].items, {}, comptime std.sort.desc(i32));
    while (i < len) : (i += 1) {
        const a: i32 = lists.items[0].pop();
        const b: i32 = lists.items[1].pop();
        sum += @abs(a - b);
    }

    const time_end = std.time.milliTimestamp();
    std.debug.print("part 1: {d} time: {d}\n", .{ sum, time_end - time_start });
}

fn test_data2(allocator: Allocator, data: std.ArrayList(std.ArrayList(i32))) !void {
    const time_start = std.time.milliTimestamp();

    var sum: i32 = 0;

    var lists = try std.ArrayList(std.ArrayList(i32)).initCapacity(allocator, 2);

    var list0 = std.ArrayList(i32).init(allocator);
    var list1 = std.ArrayList(i32).init(allocator);
    for (data.items) |row| {
        try list0.append(row.items[0]);
        try list1.append(row.items[1]);
    }
    try lists.append(list0);
    try lists.append(list1);

    var i: usize = 0;
    while (i < lists.items[0].items.len) : (i += 1) {
        const a: i32 = lists.items[0].items[i];
        var b: i32 = 0;
        for (lists.items[1].items) |val| {
            if (val == a) {
                b += 1;
            }
        }
        sum += a * b;
    }

    const time_end = std.time.milliTimestamp();
    std.debug.print("part 2: {d} time: {d}\n", .{ sum, time_end - time_start });
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    std.debug.print("\nHello, Day 1!\n\n", .{});

    // var data = try loadData(allocator, TEST_FILE);
    var data = try loadData(allocator, DATA_FILE);
    defer {
        for (data.items) |row| {
            row.deinit();
        }
        data.deinit();
    }

    try test_data1(allocator, data);
    try test_data2(allocator, data);

    std.debug.print("\nfin\n", .{});
}
