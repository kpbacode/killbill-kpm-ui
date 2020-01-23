function refreshLogLine(log) {
    var table = window.logsDataTable;
    if (table === null) {
        return;
    }

    var levelLabel = 'success';
    if (log['level'] === 'ERROR') {
        levelLabel = 'danger';
    } else if (log['level'] === 'WARNING') {
        levelLabel = 'warning';
    }

    var newDate = new Date();
    newDate.setTime(log['time']);
    var newRow = $('<tr>')
        .append($('<td>').text(newDate.toISOString()))
        .append($('<td>')
            .append($('<span>')
                .attr('class', 'label label-' + levelLabel)
                .text(log['level'])
            )
        )
        .append($('<td>')
            .append($('<pre>')
                .text(log['message'])
            )
        );

    // Enforce ordering on refresh to remove oldest entry (expected at the bottom)
    table.order([0, 'desc']).draw();

    // length needs to match pageLength in initializer
    if (table.column(0).data().length >= 100) {
        table.row($('tr:last')).remove();
    }

    table.rows.add(newRow).draw();
}

function refreshLogs(url) {
    var source = new EventSource(url);
    source.addEventListener('refresh', function (e) {
        if (e['data'] !== 'heartbeat') {
            refreshLogLine(JSON.parse(e.data));
        }
    });
}
