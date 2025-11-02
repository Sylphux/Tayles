module SessionsHelper
    def shorten_text(s, n)
        return (s[0..n-3] + "...")
    end
end