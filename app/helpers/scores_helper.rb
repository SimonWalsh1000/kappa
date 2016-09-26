module ScoresHelper


   def get_users(options = { institution: nil, experience_lower: nil, experience_upper: nil, country: nil, meeting: nil, ipf_number: nil} )

    # use this query for analysis of experts only.
    # query = Score.all.where(status: "true")

    query = Score.all

    if options[:experience_lower].present?
      query = query.where("experience >= ?", options[:experience_lower])
    elsif options[:experience_upper].present?
      query = query.where("experience <=?", options[:experience_upper])
    end
    if options[:country].present?
      query = query.where(country: options[:country])
    end
    if options[:meeting].present?
      query = query.where(meeting_type: options[:meeting])
    end
    if options[:institution].present?
      query = query.where(institution: options[:institution])
    end
    if options[:ipf_number].present?
      query = query.where( ipf_number_cases: options[:ipf_number])
    end
    query.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| k }
    @query = query.group(:user_id).count.sort_by {|_key, value| value}.map { |k, v| k }
 end



  def kappa(rater1_id, rater2_id, disease)

  score_number = 60

  # Get the observers
  @rater1 = Score.where(user_id: rater1_id).map { |r| r.attributes[disease] }
  @rater2 = Score.where(user_id: rater2_id).map { |r| r.attributes[disease] }

  # create the hashes
  @r1 = Hash[(1...@rater1.size + 1).zip @rater1]
  @r2 = Hash[(1...@rater2.size + 1).zip @rater2]


  # generate the matrix

  @zeros_count = @r1.select { |k,i| i == 0 && @r2[k] == 0 }.count
  @ones_count = @r1.select { |k,i| i == 0 && @r2[k] == 1 }.count
  @twos_count = @r1.select { |k,i| i == 0 && @r2[k] == 2 }.count
  @threes_count = @r1.select { |k,i| i == 0 && @r2[k] == 3 }.count
  @fours_count = @r1.select { |k,i| i == 0 && @r2[k] == 4 }.count
  @array_0 = [@zeros_count,@ones_count,@twos_count,@threes_count,@fours_count]

  @zeros_count = @r1.select { |k,i| i == 1 && @r2[k] == 0 }.count
  @ones_count = @r1.select { |k,i| i == 1 && @r2[k] == 1 }.count
  @twos_count = @r1.select { |k,i| i == 1 && @r2[k] == 2 }.count
  @threes_count = @r1.select { |k,i| i == 1 && @r2[k] == 3 }.count
  @fours_count = @r1.select { |k,i| i == 1 && @r2[k] == 4 }.count
  @array_1 = [@zeros_count,@ones_count,@twos_count,@threes_count,@fours_count]

  @zeros_count = @r1.select { |k,i| i == 2 && @r2[k] == 0 }.count
  @ones_count = @r1.select { |k,i| i == 2 && @r2[k] == 1 }.count
  @twos_count = @r1.select { |k,i| i == 2 && @r2[k] == 2 }.count
  @threes_count = @r1.select { |k,i| i == 2 && @r2[k] == 3 }.count
  @fours_count = @r1.select { |k,i| i == 2 && @r2[k] == 4 }.count
  @array_2 = [@zeros_count,@ones_count,@twos_count,@threes_count,@fours_count]

  @zeros_count = @r1.select { |k,i| i == 3 && @r2[k] == 0 }.count
  @ones_count = @r1.select { |k,i| i == 3 && @r2[k] == 1 }.count
  @twos_count = @r1.select { |k,i| i == 3 && @r2[k] == 2 }.count
  @threes_count = @r1.select { |k,i| i == 3 && @r2[k] == 3 }.count
  @fours_count = @r1.select { |k,i| i == 3 && @r2[k] == 4 }.count
  @array_3 = [@zeros_count,@ones_count,@twos_count,@threes_count,@fours_count]


  @zeros_count = @r1.select { |k,i| i == 4 && @r2[k] == 0 }.count
  @ones_count  = @r1.select { |k,i| i == 4 && @r2[k] == 1 }.count
  @twos_count= @r1.select { |k,i| i == 4 && @r2[k] == 2 }.count
  @threes_count = @r1.select { |k,i| i == 4 && @r2[k] == 3 }.count
  @fours_count = @r1.select { |k,i| i == 4 && @r2[k] == 4 }.count
  @array_4 = [@zeros_count,@ones_count,@twos_count,@threes_count,@fours_count]

  # actual agreements
  @sigma_agreements = @array_0[0] + @array_1[1] + @array_2[2] + @array_3[3] + @array_4[4]

  # expected agreements
  @total =
      (@array_0.inject(0){|sum,x| sum + x } +
          @array_1.inject(0){|sum,x| sum + x } +
          @array_2.inject(0){|sum,x| sum + x } +
          @array_3.inject(0){|sum,x| sum + x } +
          @array_4.inject(0){|sum,x| sum + x })


  @ef0 = (@array_0.inject(0){|sum,x| sum + x }) * (@array_0[0] + @array_1[0] + @array_2[0] + @array_3[0] + @array_4[0])/@total.to_f
  @ef1 =  (@array_1.inject(0){|sum,x| sum + x }) * (@array_0[1] + @array_1[1] + @array_2[1] + @array_3[1] + @array_4[1])/@total.to_f
  @ef2 = (@array_2.inject(0){|sum,x| sum + x }) * (@array_0[2] + @array_1[2] + @array_2[2] + @array_3[2] + @array_4[2])/@total.to_f
  @ef3 = (@array_3.inject(0){|sum,x| sum + x }) * (@array_0[3] + @array_1[3] + @array_2[3] + @array_3[3] + @array_4[3])/@total.to_f
  @ef4 = (@array_4.inject(0){|sum,x| sum + x }) * (@array_0[4] + @array_1[4] + @array_2[4] + @array_3[4] + @array_4[4])/@total.to_f


  @sigma_expected = @ef0 + @ef1 + @ef2 + @ef3 + @ef4

  # calculate kappa

  # ipf
  # @kappa = (@sigma_agreements - @sigma_expected)/(score_number - @sigma_expected)

  # nodule
  @kappa = (@sigma_agreements - @sigma_expected)/(score_number - @sigma_expected)


  # 1.0000   0.9375   0.7500   0.4375   0.0000
  # 0.9375   1.0000   0.9375   0.7500   0.4375
  # 0.7500   0.9375   1.0000   0.9375   0.7500
  # 0.4375   0.7500   0.9375   1.0000   0.9375
  # 0.0000   0.4375   0.7500   0.9375   1.0000

  @zeros_count = @r1.select { |k,i| i == 0 && @r2[k] == 0 }.count
  @ones_count = @r1.select { |k,i| i == 0 && @r2[k] == 1 }.count
  @twos_count = @r1.select { |k,i| i == 0 && @r2[k] == 2 }.count
  @threes_count = @r1.select { |k,i| i == 0 && @r2[k] == 3 }.count
  @fours_count = @r1.select { |k,i| i == 0 && @r2[k] == 4 }.count
  @array_0W = [@zeros_count * 1.0000 , @ones_count * 0.9375 , @twos_count * 0.7500 , @threes_count * 0.4375 , @fours_count * 0.0000]

  @zeros_count = @r1.select { |k,i| i == 1 && @r2[k] == 0 }.count
  @ones_count = @r1.select { |k,i| i == 1 && @r2[k] == 1 }.count
  @twos_count = @r1.select { |k,i| i == 1 && @r2[k] == 2 }.count
  @threes_count = @r1.select { |k,i| i == 1 && @r2[k] == 3 }.count
  @fours_count = @r1.select { |k,i| i == 1 && @r2[k] == 4 }.count
  @array_1W = [@zeros_count * 0.9375 , @ones_count * 1.0000 , @twos_count * 0.9375 , @threes_count * 0.7500 , @fours_count * 0.4375 ]

  @zeros_count = @r1.select { |k,i| i == 2 && @r2[k] == 0 }.count
  @ones_count = @r1.select { |k,i| i == 2 && @r2[k] == 1 }.count
  @twos_count = @r1.select { |k,i| i == 2 && @r2[k] == 2 }.count
  @threes_count = @r1.select { |k,i| i == 2 && @r2[k] == 3 }.count
  @fours_count = @r1.select { |k,i| i == 2 && @r2[k] == 4 }.count
  @array_2W = [@zeros_count * 0.7500 , @ones_count * 0.9375 , @twos_count * 1.0000 , @threes_count * 0.9375 , @fours_count * 0.7500 ]

  @zeros_count = @r1.select { |k,i| i == 3 && @r2[k] == 0 }.count
  @ones_count = @r1.select { |k,i| i == 3 && @r2[k] == 1 }.count
  @twos_count = @r1.select { |k,i| i == 3 && @r2[k] == 2 }.count
  @threes_count = @r1.select { |k,i| i == 3 && @r2[k] == 3 }.count
  @fours_count = @r1.select { |k,i| i == 3 && @r2[k] == 4 }.count
  @array_3W = [@zeros_count * 0.4375 , @ones_count * 0.7500 , @twos_count * 0.9375 , @threes_count * 1.0000 , @fours_count * 0.9375 ]


  @zeros_count = @r1.select { |k,i| i == 4 && @r2[k] == 0 }.count
  @ones_count  = @r1.select { |k,i| i == 4 && @r2[k] == 1 }.count
  @twos_count= @r1.select { |k,i| i == 4 && @r2[k] == 2 }.count
  @threes_count = @r1.select { |k,i| i == 4 && @r2[k] == 3 }.count
  @fours_count = @r1.select { |k,i| i == 4 && @r2[k] == 4 }.count
  @array_4W = [@zeros_count * 0.0000 , @ones_count * 0.4375 , @twos_count * 0.7500 , @threes_count * 0.9375 , @fours_count * 1.0000 ]


  @c_0_0 = @ef0.round(3)
  @c_0_1 = (((@array_0.inject(0){|sum,x| sum + x }) * (@array_0[1] + @array_1[1] + @array_2[1] + @array_3[1] + @array_4[1])).to_f/score_number).round(3)
  @c_0_2 = (((@array_0.inject(0){|sum,x| sum + x }) * (@array_0[2] + @array_1[2] + @array_2[2] + @array_3[2] + @array_4[2])).to_f/score_number).round(3)
  @c_0_3 = (((@array_0.inject(0){|sum,x| sum + x }) * (@array_0[3] + @array_1[3] + @array_2[3] + @array_3[3] + @array_4[3])).to_f/score_number).round(3)
  @c_0_4 = (((@array_0.inject(0){|sum,x| sum + x }) * (@array_0[4] + @array_1[4] + @array_2[4] + @array_3[4] + @array_4[4])).to_f/score_number).round(3)


  @c_1_0 = (((@array_1.inject(0){|sum,x| sum + x }) * (@array_0[0] + @array_1[0] + @array_2[0] + @array_3[0] + @array_4[0])).to_f/score_number).round(3)
  @c_1_1 = @ef1.round(3)
  @c_1_2 = (((@array_1.inject(0){|sum,x| sum + x }) * (@array_0[2] + @array_1[2] + @array_2[2] + @array_3[2] + @array_4[2])).to_f/score_number).round(3)
  @c_1_3 = (((@array_1.inject(0){|sum,x| sum + x }) * (@array_0[3] + @array_1[3] + @array_2[3] + @array_3[3] + @array_4[3])).to_f/score_number).round(3)
  @c_1_4 = (((@array_1.inject(0){|sum,x| sum + x }) * (@array_0[4] + @array_1[4] + @array_2[4] + @array_3[4] + @array_4[4])).to_f/score_number).round(3)


  @c_2_0 = (((@array_2.inject(0){|sum,x| sum + x }) * (@array_0[0] + @array_1[0] + @array_2[0] + @array_3[0] + @array_4[0])).to_f/score_number).round(3)
  @c_2_1 = (((@array_2.inject(0){|sum,x| sum + x }) * (@array_0[1] + @array_1[1] + @array_2[1] + @array_3[1] + @array_4[1])).to_f/score_number).round(3)
  @c_2_2 = @ef2.round(3)
  @c_2_3 = (((@array_2.inject(0){|sum,x| sum + x }) * (@array_0[3] + @array_1[3] + @array_2[3] + @array_3[3] + @array_4[3])).to_f/score_number).round(3)
  @c_2_4 = (((@array_2.inject(0){|sum,x| sum + x }) * (@array_0[4] + @array_1[4] + @array_2[4] + @array_3[4] + @array_4[4])).to_f/score_number).round(3)


  @c_3_0 = (((@array_3.inject(0){|sum,x| sum + x }) * (@array_0[0] + @array_1[0] + @array_2[0] + @array_3[0] + @array_4[0])).to_f/score_number).round(3)
  @c_3_1 = (((@array_3.inject(0){|sum,x| sum + x }) * (@array_0[1] + @array_1[1] + @array_2[1] + @array_3[1] + @array_4[1])).to_f/score_number).round(3)
  @c_3_2 = (((@array_3.inject(0){|sum,x| sum + x }) * (@array_0[2] + @array_1[2] + @array_2[2] + @array_3[2] + @array_4[2])).to_f/score_number).round(3)
  @c_3_3 = @ef3.round(3)
  @c_3_4 = (((@array_3.inject(0){|sum,x| sum + x }) * (@array_0[4] + @array_1[4] + @array_2[4] + @array_3[4] + @array_4[4])).to_f/score_number).round(3)


  @c_4_0 = (((@array_4.inject(0){|sum,x| sum + x }) * (@array_0[0] + @array_1[0] + @array_2[0] + @array_3[0] + @array_4[0])).to_f/score_number).round(3)
  @c_4_1 = (((@array_4.inject(0){|sum,x| sum + x }) * (@array_0[1] + @array_1[1] + @array_2[1] + @array_3[1] + @array_4[1])).to_f/score_number).round(3)
  @c_4_2 = (((@array_4.inject(0){|sum,x| sum + x }) * (@array_0[2] + @array_1[2] + @array_2[2] + @array_3[2] + @array_4[2])).to_f/score_number).round(3)
  @c_4_3 = (((@array_4.inject(0){|sum,x| sum + x }) * (@array_0[3] + @array_1[3] + @array_2[3] + @array_3[3] + @array_4[3])).to_f/score_number).round(3)
  @c_4_4 = @ef4.round(3)

  @w_expected = @c_0_0 * 1.0000 + @c_0_1 * 0.9375 + @c_0_2 * 0.7500 +  @c_0_3 * 0.4375 + @c_0_4 * 0.0000 +
      @c_1_0 * 0.9375 + @c_1_1 * 1.0000 + @c_1_2 * 0.9375 +  @c_1_3 * 0.7500 + @c_1_4 * 0.4375 +
      @c_2_0 * 0.7500 + @c_2_1 * 0.9375 + @c_2_2 * 1.0000 +  @c_2_3 * 0.9375 + @c_2_4 * 0.7500 +
      @c_3_0 * 0.4375 + @c_3_1 * 0.7500 + @c_3_2 * 0.9375 + @c_3_3 * 1.0000 +  @c_3_4 * 0.9375 +
      @c_4_0 * 0.0000 + @c_4_1 * 0.4375 + @c_4_2 * 0.7500 + @c_4_3 * 0.9375 + @c_4_4 * 1.0000

      # 1.0000   0.9375   0.7500   0.4375   0.000
      # 0.9375   1.0000   0.9375   0.7500   0.4375
      # 0.7500   0.9375   1.0000   0.9375   0.7500
      # 0.4375   0.7500   0.9375   1.0000   0.9375
      # 0.0000   0.4375   0.7500   0.9375   1.0000



  @w_actual =   @array_0W.inject(0){|sum,x| sum + x } +
      @array_1W.inject(0){|sum,x| sum + x } +
      @array_2W.inject(0){|sum,x| sum + x } +
      @array_3W.inject(0){|sum,x| sum + x } +
      @array_4W.inject(0){|sum,x| sum + x }

  @weighted_kappa = (@w_actual - @w_expected)/(score_number - @w_expected)

  end

  def get_kappas(array, disease)
    @result = array.each_with_object({ }) do |u, h|
      array.each do |p|
        next if (u == p)
        h[[u, p].sort] ||= kappa(u, p, disease)
      end
    end
  end

  def median(hash)
    if hash.present?
      array = hash.map {|k, v| v }
      sorted = array.sort
      len = sorted.length
      (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
    else
      return
    end
  end

  def calculate_percentile(hash, percentile)
   array = hash.map {|k, v| v }
   array.sort[(percentile * array.length).ceil - 1]
  end

  def mgt_types(string)
   if string == "Observation"
    return "0"
   elsif string == "Immunomodulation"
    return "1"
   elsif string == "IPF-specific therapy (i.e. Nintedanib, Pirfenidone) assuming the patient satisfies local prescribing criteria"
    return "2"
   elsif string == "IPF-specific therapy, (i.e. Nintedanib, Pirfenidone), if it were available in my country"
    return "2"
   elsif string == "Other (e.g GM-CSF for alveolar proteinosis. Please specify in the comments)"
    return "3"
   end
  end



















end
