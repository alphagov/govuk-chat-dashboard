function humanize(title) {
  title = title.replaceAll("_", " ")
  return title.charAt(0).toUpperCase() + title.slice(1)
}

function buildChart(chart) {
  var ctx = document.getElementById(chart.label)
  var keys = new Array()
  var values = new Array()

  for (var key in chart.data) {
    keys.push(key)
    values.push(chart.data[key])
  }

  Chart.defaults.set(
    "plugins.datalabels", {
      color: "#ffffff",
      font: {
        weight: "bold",
        size: 18
      }
    }
  )

  // Chart colours from here: https://analysisfunction.civilservice.gov.uk/policy-store/data-visualisation-colours-in-charts/
  // as recommended here: https://design-system.service.gov.uk/styles/colour/
  new Chart(ctx, {
    plugins: [ChartDataLabels],
    type: "bar",
    data: {
      labels: keys,
      datasets: [{
        label: chart.label,
        data: values,
        borderWidth: 0,
        backgroundColor: [
          "rgb(18, 67, 109)",
          "rgb(40, 161, 151)",
          "rgb(128, 22, 80)",
          "rgb(244, 106, 37)",
          "rgb(61, 61, 61)",
          "rgb(162, 133, 209)",
          "rgb(32, 115, 188)",
          "rgb(107, 172, 230)"
        ]
      }]
    },
    options: {
      indexAxis: "y",
      onClick: chartClick,
      plugins: {
        title: {
          display: true,
          align: "center",
          position: "top",
          color: "#000000",
          padding: {
            top: 80,
            bottom: 30
          },
          font: {
            weight: "bold",
            size: 42
          },
          text: humanize(chart.label)
        },
        datalabels: {
          font: {
            weight: "normal",
            size: 12
          },
          formatter: (value, ctx) => {
            const datapoints = ctx.chart.data.datasets[0].data
            const total = datapoints.reduce((total, datapoint) => total + datapoint, 0)
            const percentage = value / total * 100
            return value + " (" + percentage.toFixed(2) + "%)";
          }
        }
      }
    }
  })
}

function chartClick(event, array) {
  // This is ok for simple charts with a single dataset
  // But, may not work correctly for anything stacked!
  var labels = event.chart.config._config.data.labels
  var answer = labels[array[0].index]
  var chartName = event.chart.canvas.id
  var obj = { header: chartName, value: answer }
  window.location = "/answers?" + new URLSearchParams(obj).toString();
}

function percentage(x, y) {
  var percentage = ((x / y) * 100)
  return "(" + percentage.toFixed(2) + "%)"
}

function buildTable(chart) {
  var ctx = document.getElementById("data")

  var table = document.createElement("table")
  var thead = document.createElement("thead")
  var row = document.createElement("tr")

  var answer = document.createElement("th")
  var answerText = document.createTextNode("Answer")
  answer.appendChild(answerText)

  var count = document.createElement("th")
  var countText = document.createTextNode("Count")
  count.appendChild(countText)

  var percent = document.createElement("th")
  var percentText = document.createTextNode("Percentage")
  percent.appendChild(percentText)

  row.appendChild(answer)
  row.appendChild(count)
  row.appendChild(percent)
  thead.appendChild(row)
  table.appendChild(thead)

  var tbody = document.createElement("tbody")

  var total = 0
  for (var key in chart.data) {
    total += chart.data[key]
  }

  for (key in chart.data) {
    var row = document.createElement("tr")

    var answer = document.createElement("td")
    var link = document.createElement("a")
    link.href = "/answers?" + new URLSearchParams({ header: chart.label, value: key }).toString()
    var answerText = document.createTextNode(key)
    link.appendChild(answerText)
    answer.appendChild(link)

    var count = document.createElement("td")
    var countText = document.createTextNode(chart.data[key])
    count.appendChild(countText)

    var percent = document.createElement("td")
    var percentText = document.createTextNode(percentage(chart.data[key], total))
    percent.appendChild(percentText)

    row.appendChild(answer)
    row.appendChild(count)
    row.appendChild(percent)
    tbody.appendChild(row)
  }

  table.appendChild(tbody)
  ctx.append(table)

  var para = document.createElement("p")
  para.className = "centered"
  var ital = document.createElement("i")
  var text = document.createTextNode("Click on the chart or links in the table to view more data.")
  ital.appendChild(text)
  para.appendChild(ital)
  ctx.append(para)
}
