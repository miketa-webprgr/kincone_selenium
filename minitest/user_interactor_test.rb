require 'minitest/autorun'
require 'byebug'
require '../user_interactor'

describe 'Storing methods' do
  # Kernelのstub方法が不明のため、テストしない
  describe 'store_yes_or_no' do; end

  describe 'store_date_of_last_month' do
    it 'stores the date of last month to interactor' do
      @interactor = UserInteractor.new
       @interactor.store_date_of_last_month
      
      assert_equal Time.current.last_month.year, @interactor.year
      assert_equal Time.current.last_month.month, @interactor.month
    end
  end

  # Kernelのstub方法が不明のため、テストしない
  describe 'store_year' do; end

  # Kernelのstub方法が不明のため、テストしない
  describe 'store_month' do; end

  # Kernelのstub方法が不明のため、テストしない
  describe 'store_rest_start' do; end

  # Kernelのstub方法が不明のため、テストしない
  describe 'store_rest_end' do; end

  describe 'store_should_override' do
    it 'stores true to should_override attribute' do
      @interactor = UserInteractor.new
      @interactor.yes_or_no = 'y'
      @interactor.store_should_override
      
      assert_equal true, @interactor.should_override
    end

    it 'stores false to should_override attribute' do
      @interactor = UserInteractor.new
      @interactor.yes_or_no = 'n'
      @interactor.store_should_override

      assert_equal false, @interactor.should_override
    end
  end
end

describe 'Validations' do
  describe 'passes_validate_yes_or_no?' do
    it 'returns true when yes? is true' do
      @interactor = UserInteractor.new
      @interactor.stub :yes?, true do
        assert_equal true, @interactor.passes_validate_yes_or_no?
      end
    end

    it 'returns true when no? is true' do
      @interactor = UserInteractor.new
      @interactor.stub :no?, true do
        assert_equal true, @interactor.passes_validate_yes_or_no?
      end
    end

    it 'returns true when yes? and no? is both false' do
      @interactor = UserInteractor.new
      @interactor.stub :yes?, false do
        @interactor.stub :no?, false do
          assert_equal false, @interactor.passes_validate_yes_or_no?
        end
      end
    end
  end

  describe 'passes_validate_year?' do
    it 'returns true when 2000' do
      @interactor = UserInteractor.new
      @interactor.year = 2000

      assert_equal true, @interactor.passes_validate_year?
    end

    it 'returns true when 2099' do
      @interactor = UserInteractor.new
      @interactor.year = 2099

      assert_equal true, @interactor.passes_validate_year?
    end

    it 'returns false when 1999' do
      @interactor = UserInteractor.new
      @interactor.year = 1999

      assert_equal false, @interactor.passes_validate_year?
    end

    it 'returns false when 2100' do
      @interactor = UserInteractor.new
      @interactor.year = 2100

      assert_equal false, @interactor.passes_validate_year?
    end

    it 'returns false when hogehoge' do
      @interactor = UserInteractor.new
      @interactor.year = 'hogehoge'

      assert_equal false, @interactor.passes_validate_year?
    end
  end

  describe 'passes_validate_month?' do
    it 'returns true when 1' do
      @interactor = UserInteractor.new
      @interactor.month = 1

      assert_equal true, @interactor.passes_validate_month?
    end

    it 'returns true when 12' do
      @interactor = UserInteractor.new
      @interactor.month = 12

      assert_equal true, @interactor.passes_validate_month?
    end

    it 'returns false when 0' do
      @interactor = UserInteractor.new
      @interactor.month = 0

      assert_equal false, @interactor.passes_validate_month?
    end

    it 'returns false when 13' do
      @interactor = UserInteractor.new
      @interactor.month = 13

      assert_equal false, @interactor.passes_validate_month?
    end

    it 'returns false when hogehoge' do
      @interactor = UserInteractor.new
      @interactor.month = 'hogehoge'

      assert_equal false, @interactor.passes_validate_month?
    end
  end

  describe 'passes_validate_rest_start?' do
    it 'returns true when passes_validate_rest_start? is true' do
      @interactor = UserInteractor.new
      @interactor.stub :passes_validate_time?, true do
        assert_equal true, @interactor.passes_validate_rest_start?
      end
    end

    it 'returns false when passes_validate_rest_start? is false' do
      @interactor = UserInteractor.new
      @interactor.stub :passes_validate_time?, false do
        assert_equal false, @interactor.passes_validate_rest_start?
      end
    end
  end

  describe 'passes_validate_rest_end?' do
    describe 'when passes_validate_time? is true' do
      it 'returns true when rest_start_earlier_than_rest_end? is true' do
        @interactor = UserInteractor.new
        @interactor.stub :passes_validate_time?, true do
          @interactor.stub :rest_start_earlier_than_rest_end?, true do 
            assert_equal true, @interactor.passes_validate_rest_end?
          end
        end
      end

      it 'returns false when rest_start_earlier_than_rest_end? is false' do
        @interactor = UserInteractor.new
        @interactor.stub :passes_validate_time?, true do
          @interactor.stub :rest_start_earlier_than_rest_end?, false do 
            assert_equal false, @interactor.passes_validate_rest_end?
          end
        end
      end
    end

    describe 'when passes_validate_time? is false' do
      it 'returns true when rest_start_earlier_than_rest_end? is true' do
        @interactor = UserInteractor.new
        @interactor.stub :passes_validate_time?, false do
          @interactor.stub :rest_start_earlier_than_rest_end?, true do 
            assert_equal false, @interactor.passes_validate_rest_end?
          end
        end
      end

      it 'returns false when rest_start_earlier_than_rest_end? is false' do
        @interactor = UserInteractor.new
        @interactor.stub :passes_validate_time?, false do
          @interactor.stub :rest_start_earlier_than_rest_end?, false do 
            assert_equal false, @interactor.passes_validate_rest_end?
          end
        end
      end
    end
  end
end

describe 'Helper' do
  describe 'yes?' do 
    it 'returns true with y' do
      @interactor = UserInteractor.new
      @interactor.yes_or_no = 'y'

      assert_equal true, @interactor.yes?
    end

    it 'returns true with Y' do
      @interactor = UserInteractor.new
      @interactor.yes_or_no = 'Y'

      assert_equal true, @interactor.yes?
    end

    it 'returns false with n' do
      @interactor = UserInteractor.new
      @interactor.yes_or_no = 'n'

      assert_equal false, @interactor.yes?
    end

    it 'returns false with 58320513' do
      @interactor = UserInteractor.new
      @interactor.yes_or_no = 58320513

      assert_equal false, @interactor.yes?
    end
  end

  describe 'no?' do 
    it 'returns true with N' do
      @interactor = UserInteractor.new
      @interactor.yes_or_no = 'N'

      assert_equal true, @interactor.no?
    end

    it 'returns true with n' do
      @interactor = UserInteractor.new
      @interactor.yes_or_no = 'n'

      assert_equal true, @interactor.no?
    end

    it 'returns false with y' do
      @interactor = UserInteractor.new
      @interactor.yes_or_no = 'y'

      assert_equal false, @interactor.no?
    end

    it 'returns true with 58320513' do
      @interactor = UserInteractor.new
      @interactor.yes_or_no = 58320513

      assert_equal false, @interactor.no?
    end
  end

  describe 'passes_validate_time?' do
    it 'returns true when 12:00' do
      @interactor = UserInteractor.new
      assert_equal true, @interactor.passes_validate_time?('12:00')
    end

    it 'returns true when 20:00' do
      @interactor = UserInteractor.new
      assert_equal true, @interactor.passes_validate_time?('20:00')
    end

    it 'returns true when 09:00' do
      @interactor = UserInteractor.new
      assert_equal true, @interactor.passes_validate_time?('09:00')
    end

    it 'returns true when 9:00' do
      @interactor = UserInteractor.new
      assert_equal true, @interactor.passes_validate_time?('9:00')
    end

    it 'returns true when 9:49' do
      @interactor = UserInteractor.new
      assert_equal true, @interactor.passes_validate_time?('9:49')
    end

    it 'returns false when 9:79' do
      @interactor = UserInteractor.new
      assert_equal false, @interactor.passes_validate_time?('9:79')
    end

    it 'returns false when 29:49' do
      @interactor = UserInteractor.new
      assert_equal false, @interactor.passes_validate_time?('29:49')
    end

    it 'returns false when 949' do
      @interactor = UserInteractor.new
      assert_equal false, @interactor.passes_validate_time?('949')
    end

    it 'returns false when 9' do
      @interactor = UserInteractor.new
      assert_equal false, @interactor.passes_validate_time?('9')
    end

    it 'returns false when hogehgoe' do
      @interactor = UserInteractor.new
      assert_equal false, @interactor.passes_validate_time?('hogehoeg')
    end
  end

  describe 'rest_start_earlier_than_rest_end?' do
    it 'returns true when 12:00 and 13:00' do
      @interactor = UserInteractor.new
      @interactor.rest_start = '12:00'
      @interactor.rest_end = '13:00'

      assert_equal true, @interactor.rest_start_earlier_than_rest_end?
    end
    
    it 'returns false when 13:00 and 13:00' do
      @interactor = UserInteractor.new
      @interactor.rest_start = '13:00'
      @interactor.rest_end = '13:00'

      assert_equal false, @interactor.rest_start_earlier_than_rest_end?
    end

    it 'returns false when 13:01 and 13:00' do
      @interactor = UserInteractor.new
      @interactor.rest_start = '13:01'
      @interactor.rest_end = '13:00'

      assert_equal false, @interactor.rest_start_earlier_than_rest_end?
    end
  end
end