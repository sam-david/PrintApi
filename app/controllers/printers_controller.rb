class PrintersController < ApplicationController
  def log_point
    printer_stats = octo_client.info
    job_stats = octo_client.job

    if printer_stats.parsed_response == "Printer is not operational"
      render json: ["Printer not operational"]
    else

      current_job = Job.find_or_create_by(gcode_title: job_stats['job']['file']['name'])
      current_job.actual_filament_length = job_stats['job']['filament']['tool0']['length']
      current_job.display_title = job_stats['job']['file']['display']
      current_job.save

      # parse history?
      print_log = PrintLog.new(
        tool_temp: printer_stats['temperature']['tool0']['actual'],
        bed_temp: printer_stats['temperature']['bed']['actual'],
        filament_length: job_stats['job']['filament']['tool0']['length'],
        estimated_total_print_time: job_stats['job']['estimatedPrintTime'],
        completion_percentage: job_stats['progress']['completion'],
        print_time: job_stats['progress']['printTime'],
        print_time_left: job_stats['progress']['printTime'],
        logged_at: Time.now,
        state: printer_stats['state']['text']
      )
      print_log.job = current_job

      print_log.save

      render json: print_log
    end
  end

  private

  def octo_client
    OctoClient.new(params[:printer])
  end
end
