class YARD::CLI::Yardoc

  # def run(*args)
  #   parse_arguments(*args)
  #   
  #   checksums = nil
  #   if use_cache
  #     Registry.load
  #     checksums = Registry.checksums.dup
  #   end
  #   YARD.parse(files, excluded)
  #   Registry.save(use_cache) if save_yardoc
  #   
  #   if generate
  #     run_generate(checksums)
  #     copy_assets
  #   elsif list
  #     print_list
  #   end
  # 
  #   if !list && statistics && log.level < Logger::ERROR
  #     Registry.load_all
  #     log.enter_level(Logger::ERROR) do
  #       Stats.new(false).run(*args)
  #     end
  #   end
  #           
  #   true
  # end
  def run(*args)
    parse_arguments(*args)
    
    checksums = nil
    if use_cache
      ::YARD::Registry.load
      checksums = ::YARD::Registry.checksums.dup
    end
    YARD.parse(files, excluded)
    config = YardTiiExtensions::DocConfig.instance
    YardTiiExtensions::YardRoutesEngine.load_routes_into_registry! if config.need_routes?
    YardTiiExtensions::LiquidCustomizationMdGenerator.render! if config.document_liquid?
    ::YARD::Registry.save(use_cache) if save_yardoc
    
    if generate
      run_generate(checksums)
      copy_assets
    elsif list
      print_list
    end

    if !list && statistics && log.level < Logger::ERROR
      ::YARD::Registry.load_all
      log.enter_level(Logger::ERROR) do
        ::YARD::CLI::Stats.new(false).run(*args)
      end
    end
            
    true
  end
end