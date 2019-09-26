function refreshLogLine(log) {
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

    var tableRows = $("#logs-table tr");
    if (tableRows.length === 2) {
        $("#logs-table tr .dataTables_empty").remove()
    }
    if (tableRows.length > 1) {
        $("#logs-table > tbody > tr:first").before(newRow);
    } else {
        // Shouldn't happen?
        $("#logs-table > tbody").append(newRow);
    }
    if (tableRows.length >= 50) {
        $('#logs-table tr:last').remove();
    }
}

function refreshLogs(url) {
    var source = new EventSource(url);
    source.addEventListener('refresh', function (e) {
        if (e['data'] !== 'heartbeat') {
            refreshLogLine(JSON.parse(e.data));
        }
    });
}
